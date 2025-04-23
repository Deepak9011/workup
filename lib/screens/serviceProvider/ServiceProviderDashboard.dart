import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:workup/models/Bid.dart';
import 'package:workup/utils/colors.dart';
import 'dart:convert';

import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/sp_bottom_navigation_bar.dart';

class ServiceProviderDashboard extends StatefulWidget {
  final String bidId;

  const ServiceProviderDashboard({Key? key, required this.bidId})
      : super(key: key);

  @override
  _ServiceProviderDashboardState createState() =>
      _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends State<ServiceProviderDashboard> {
  final String customerId = 'cust123deepak';
  List<Bid> bids = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  String? errorMessage;
  final String? apiBiddingUrl = dotenv.env['API_BIDDING_URL'];

  // New variables for About section
  Map<String, dynamic>? bidDetails;
  bool isAboutLoading = false;
  String? aboutErrorMessage;

  handleMenuClick() {
    // _scaffoldKey.currentState?.openDrawer();
  }

  handleChatClick() {}

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

  Future<void> fetchBidDetails() async {
    if (bidDetails != null) return; // Already loaded

    setState(() {
      isAboutLoading = true;
      aboutErrorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$apiBiddingUrl/bids/bid/${widget.bidId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bidDetails = data;
          isAboutLoading = false;
        });
      } else {
        throw Exception('Failed to load bid details');
      }
    } catch (e) {
      setState(() {
        isAboutLoading = false;
        aboutErrorMessage = 'Error fetching bid details: ${e.toString()}';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Fetch bid details when About tab is selected
    if (index == 3) {
      fetchBidDetails();
    }
  }

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
      body: Column(
        children: [
          // Horizontal Scrollable Tabs
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildTabButton(0, 'All Bids'),
                _buildTabButton(1, 'Queries'),
                _buildTabButton(2, 'Make a Bid'),
                _buildTabButton(3, 'About'),
              ],
            ),
          ),
          Divider(height: 1),

          // Content based on selected tab
          Expanded(
            child: _getSelectedTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: _selectedIndex == index ? Colors.blue : Colors.grey,
        ),
        onPressed: () => _onItemTapped(index),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight:
                _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _getSelectedTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAllBidsTab();
      case 1:
        return Center(child: Text('Queries Content'));
      case 2:
        return Center(
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate to bid creation screen')));
            },
            child: Text('Make a Bid'),
          ),
        );
      case 3:
        return _buildAboutTab();
      default:
        return Container();
    }
  }

  Widget _buildAllBidsTab() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    if (bids.isEmpty) {
      return Center(child: Text('No bids available'));
    }

    return ListView.builder(
      itemCount: bids.length,
      itemBuilder: (context, index) {
        final bid = bids[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('\$${bid.price}'),
            subtitle: Text(bid.description),
            trailing: Text(bid.status),
            onTap: () {
              _showBidDetails(bid);
            },
          ),
        );
      },
    );
  }

  Widget _buildAboutTab() {
    if (isAboutLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (aboutErrorMessage != null) {
      return Center(child: Text(aboutErrorMessage!));
    }

    if (bidDetails == null) {
      return Center(child: Text('No bid details available'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Bid ID:', bidDetails!['bidId']),
          _buildDetailItem('Customer ID:', bidDetails!['customerId']),
          _buildDetailItem('Service Provider ID:',
              bidDetails!['serviceProviderId'] ?? 'Not assigned'),
          _buildDetailItem(
              'Bidding Start:', _formatDateTime(bidDetails!['startBidTime'])),
          _buildDetailItem(
              'Bidding End:', _formatDateTime(bidDetails!['endBidTime'])),
          _buildDetailItem(
              'Service Time:', _formatDateTime(bidDetails!['serviceTime'])),
          _buildDetailItem('Category:', bidDetails!['category']),
          _buildDetailItem('Description:', bidDetails!['description']),
          _buildDetailItem('Maximum Amount:', '\$${bidDetails!['maxAmount']}'),
          _buildDetailItem('Address:', bidDetails!['address']),
          _buildDetailItem('State:', bidDetails!['state']),
          _buildDetailItem('Country:', bidDetails!['country']),
          _buildDetailItem(
              'Additional Notes:', bidDetails!['additionalNotes'] ?? 'None'),
          _buildDetailItem('Bid Status:', bidDetails!['bidStatus']),
          if (bidDetails!['conformCustomerId'] != null)
            _buildDetailItem(
                'Confirmed Customer:', bidDetails!['conformCustomerId']),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
          Divider(),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString; // Return original if parsing fails
    }
  }

  void _showBidDetails(Bid bid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bid Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${bid.price}'),
            SizedBox(height: 8),
            Text('Description: ${bid.description}'),
            SizedBox(height: 8),
            Text('Status: ${bid.status}'),
            SizedBox(height: 8),
            Text('Bid Time: ${bid.bidTime}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
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
