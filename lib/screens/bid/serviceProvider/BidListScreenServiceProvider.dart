import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/sp_bottom_navigation_bar.dart';

class BidListScreenServiceProvider extends StatefulWidget {
  const BidListScreenServiceProvider({Key? key}) : super(key: key);

  @override
  _BidListScreenServiceProviderState createState() =>
      _BidListScreenServiceProviderState();
}

class _BidListScreenServiceProviderState
    extends State<BidListScreenServiceProvider> {
  List<BidItem> bidItems = [];
  bool isLoading = true;
  String errorMessage = '';
  final String? apiBiddingUrl = dotenv.env['API_BIDDING_URL'];

  @override
  void initState() {
    super.initState();
    loadBids();
  }

  Future<void> loadBids() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$apiBiddingUrl/bids'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          bidItems = data.map((e) => BidItem.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load bids: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching bids: $e';
      });
    }
  }

  handleMenuClick() {
    // _scaffoldKey.currentState?.openDrawer();
  }

  handleChatClick() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Center(
            child: Text(
          "Bidding",
          style: AppTextStyles.title.merge(AppTextStyles.textWhite),
        )),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            color: AppColors.white,
          ),
          onPressed: handleMenuClick,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat_rounded,
              color: AppColors.white,
            ),
            onPressed: handleChatClick,
          )
        ],
      ),
      bottomNavigationBar: const SPCustomBottomNavigationBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : RefreshIndicator(
                  onRefresh: loadBids,
                  child: ListView.builder(
                    itemCount: bidItems.length,
                    itemBuilder: (context, index) {
                      final item = bidItems[index];
                      return BidCard(
                        item: item,
                        onMakeBid: () {
                          Navigator.pushNamed(
                            context,
                            '/serviceProviderBidDetailScreen',
                            arguments: {
                              '_id': item.bidId,
                              'customerId': item.customerId,
                              'category': item.category,
                              'description': item.description,
                              'serviceTime': item.serviceTime,
                              'startBidTime': item.startBidTime,
                              'endBidTime': item.endBidTime,
                              'maxAmount': item.maxAmount,
                              'address': item.address,
                              'state': item.state,
                              'country': item.country,
                              'additionalNotes': item.additionalNotes,
                              'image': item.image, // Pass the entire image map
                              'bidStatus': item.bidStatus,
                              'conformCustomerId': item.conformCustomerId,
                            },
                          ).then((_) {
                            // Optional: Show success message after returning from detail screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Bid placed successfully!')),
                            );
                          });
                          // _showBidConfirmation(context, item);
                        },
                        onExplore: () {
                          _showBidDetails(context, item);
                        },
                      );
                    },
                  ),
                ),
    );
  }

  // void _showBidConfirmation(BuildContext context, BidItem item) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Confirm Bid'),
  //         content:
  //             Text('Are you sure you want to bid on "${item.description}"?'),
  //         actions: [
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //           ElevatedButton(
  //             child: const Text('Confirm Bid'),
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //               Navigator.pushNamed(
  //                 context,
  //                 '/serviceProviderBidDetailScreen',
  //                 arguments: {
  //                   '_id': item.bidId,
  //                   'customerId': item.customerId,
  //                   'category': item.category,
  //                   'description': item.description,
  //                   'serviceTime': item.serviceTime,
  //                   'startBidTime': item.startBidTime,
  //                   'endBidTime': item.endBidTime,
  //                   'maxAmount': item.maxAmount,
  //                   'address': item.address,
  //                   'state': item.state,
  //                   'country': item.country,
  //                   'additionalNotes': item.additionalNotes,
  //                   'image': item.image, // Pass the entire image map
  //                   'bidStatus': item.bidStatus,
  //                   'conformCustomerId': item.conformCustomerId,
  //                 },
  //               ).then((_) {
  //                 // Optional: Show success message after returning from detail screen
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text('Bid placed successfully!')),
  //                 );
  //               });
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showBidDetails(BuildContext context, BidItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.category),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.description,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Price: \$${item.maxAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Location: ${item.address}, ${item.state}, ${item.country}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  'Service Time: ${_formatDate(item.serviceTime)}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                if (item.additionalNotes.isNotEmpty)
                  Text(
                    'Notes: ${item.additionalNotes}',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                SizedBox(height: 10),
                Text(
                  'Bid Status: ${item.bidStatus}',
                  style: TextStyle(
                    fontSize: 14,
                    color: item.bidStatus == 'Open' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }
}

class BidCard extends StatelessWidget {
  final BidItem item;
  final VoidCallback onMakeBid;
  final VoidCallback onExplore;

  const BidCard({
    Key? key,
    required this.item,
    required this.onMakeBid,
    required this.onExplore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.category,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    '${item.maxAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(item.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
              'Location: ${item.address}, ${item.state}, ${item.country}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Service Time: ${_formatDate(item.serviceTime)}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            if (item.additionalNotes.isNotEmpty)
              Text(
                'Notes: ${item.additionalNotes}',
                style:
                    TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            SizedBox(height: 8),
            Chip(
              label: Text(
                item.bidStatus,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor:
                  item.bidStatus == 'Open' ? Colors.green : Colors.red,
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: onExplore,
                  child: Text('Explore'),
                ),
                ElevatedButton(
                  onPressed: item.bidStatus == 'Open' ? onMakeBid : null,
                  child: Text('Make a Bid'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }
}

class BidItem {
  final String bidId;
  final String customerId;
  final String serviceProviderId;
  final String startBidTime;
  final String endBidTime;
  final String serviceTime;
  final String category;
  final String description;
  final double maxAmount;
  final String address;
  final String state;
  final String country;
  final String additionalNotes;
  final Map<String, dynamic> image;
  final String bidStatus;
  final String? conformCustomerId;

  BidItem({
    required this.bidId,
    required this.customerId,
    required this.serviceProviderId,
    required this.startBidTime,
    required this.endBidTime,
    required this.serviceTime,
    required this.category,
    required this.description,
    required this.maxAmount,
    required this.address,
    required this.state,
    required this.country,
    required this.additionalNotes,
    required this.image,
    required this.bidStatus,
    this.conformCustomerId,
  });

  factory BidItem.fromJson(Map<String, dynamic> json) {
    return BidItem(
      bidId: json['bidId'] ?? '',
      customerId: json['customerId'] ?? '',
      serviceProviderId: json['serviceProviderId'] ?? '',
      startBidTime: json['startBidTime'] ?? '',
      endBidTime: json['endBidTime'] ?? '',
      serviceTime: json['serviceTime'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      maxAmount: (json['maxAmount'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      additionalNotes: json['additionalNotes'] ?? '',
      image:
          json['image'] is Map ? Map<String, dynamic>.from(json['image']) : {},
      bidStatus: json['bidStatus'] ?? '',
      conformCustomerId: json['conformCustomerId'],
    );
  }
}
