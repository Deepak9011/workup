import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:workup/utils/colors.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';

class BidAcceptanceScreenCustomer extends StatefulWidget {
  final String bidId;

  const BidAcceptanceScreenCustomer({Key? key, required this.bidId})
      : super(key: key);

  @override
  _BidAcceptanceScreenCustomerState createState() =>
      _BidAcceptanceScreenCustomerState();
}

class _BidAcceptanceScreenCustomerState
    extends State<BidAcceptanceScreenCustomer> {
  List<Bid> bids = [];
  bool isLoading = true;
  String? errorMessage;
  final String? apiBiddingUrl = dotenv.env['API_BIDDING_URL'];

  @override
  void initState() {
    super.initState();
    fetchBids();
  }

  Future<void> fetchBids() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$apiBiddingUrl/bidded/bid/${widget.bidId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          bids = data.map((json) => Bid.fromJson(json)).toList();
          isLoading = false;
        });
      } else if (response.statusCode == 204) {
        setState(() {
          bids = [];
          isLoading = false;
          errorMessage = 'No bids available for this request';
        });
      } else {
        throw Exception('Failed to load bids');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching bids: ${e.toString()}';
      });
    }
  }

  Future<void> acceptBid(String biddedId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBiddingUrl/bidded/confirm'),
        body: {'biddedId': biddedId},
      );

      if (response.statusCode == 200) {
        fetchBids();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bid accepted successfully!'),
            backgroundColor: AppColors.primary,
          ),
        );
      } else {
        throw Exception('Failed to accept bid');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting bid: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      appBar: AppBar(
        title: const Text(
          'Available Bids',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchBids,
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: AppColors.darkGrey),
                  ),
                )
              : bids.isEmpty
                  ? Center(
                      child: Text(
                        'No bids available',
                        style: TextStyle(
                          color: AppColors.mediumGrey,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: fetchBids,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: bids.length,
                        itemBuilder: (context, index) {
                          final bid = bids[index];
                          return BidCard(
                            bid: bid,
                            onAccept: () => acceptBid(bid.id),
                          );
                        },
                      ),
                    ),
    );
  }
}

class BidCard extends StatelessWidget {
  final Bid bid;
  final VoidCallback onAccept;

  const BidCard({
    Key? key,
    required this.bid,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${bid.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(bid.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bid.status,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (bid.description.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bid.description,
                    style: const TextStyle(color: AppColors.mediumGrey),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posted: ${_formatDateTime(bid.bidTime)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumGrey,
                  ),
                ),
                if (bid.status == 'ACTIVE')
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Accept Bid',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return AppColors.secondary;
      case 'CONFIRMED':
        return Colors.green;
      case 'WITHDRAWN':
        return Colors.orange;
      case 'LOST':
        return Colors.red;
      default:
        return AppColors.mediumGrey;
    }
  }

  String _formatDateTime(String dateTime) {
    try {
      final parsed = DateTime.parse(dateTime);
      return '${parsed.day}/${parsed.month}/${parsed.year} ${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }
}

class Bid {
  final String id;
  final String bidId;
  final String customerId;
  final double price;
  final String description;
  final String bidTime;
  final String status;

  Bid({
    required this.id,
    required this.bidId,
    required this.customerId,
    required this.price,
    required this.description,
    required this.bidTime,
    required this.status,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'],
      bidId: json['bidId'],
      customerId: json['customerId'],
      price: json['price'].toDouble(),
      description: json['description'],
      bidTime: json['bidTime'],
      status: json['status'],
    );
  }
}
