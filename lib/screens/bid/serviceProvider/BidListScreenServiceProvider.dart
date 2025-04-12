import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';

class BidListScreenServiceProvider extends StatefulWidget {
  const BidListScreenServiceProvider({Key? key}) : super(key: key);

  @override
  _BidListScreenServiceProviderState createState() =>
      _BidListScreenServiceProviderState();
}

class _BidListScreenServiceProviderState
    extends State<BidListScreenServiceProvider> {
  List<BidItem> bidItems = [];

  @override
  void initState() {
    super.initState();
    loadBids();
  }

  void loadBids() {
    // Simulated response
    String rawResponse = '''
    [
      {
        "bidId": "67f21bb7bcdcdc16621572ce",
        "customerId": "cust123",
        "serviceProviderId": "provider456",
        "startBidTime": "2023-06-15T03:30:00",
        "endBidTime": "2023-06-20T11:30:00",
        "serviceTime": "2023-06-25T04:30:00",
        "category": "Plumbing",
        "description": "Fix leaking kitchen sink",
        "maxAmount": 150.0,
        "address": "123 Main St",
        "state": "California",
        "country": "USA",
        "additionalNotes": "Available on weekends",
        "bidStatus": "Open"
      },
      {
        "bidId": "67f279d6e2763538518dc313",
        "customerId": "deepak123",
        "serviceProviderId": "deepakprovider456",
        "startBidTime": "2025-06-15T09:00:00",
        "endBidTime": "2025-06-20T17:00:00",
        "serviceTime": "2025-06-25T10:00:00",
        "category": "Gardening",
        "description": "Cutting",
        "maxAmount": 370.0,
        "address": "Vallab Nagar, Indore",
        "state": "Madhya Pradesh",
        "country": "India",
        "additionalNotes": "Available on weekends only Sunday",
        "bidStatus": "Open"
      }
    ]
    ''';

    dynamic data = tryParseJson(rawResponse);

    if (data != null && data is List) {
      setState(() {
        bidItems = data.map((e) => BidItem.fromJson(e)).toList();
      });
    } else {
      print('Failed to load bid data');
    }
  }

  dynamic tryParseJson(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      print('Invalid JSON format: $source');
      return null;
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
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: ListView.builder(
        itemCount: bidItems.length,
        itemBuilder: (context, index) {
          final item = bidItems[index];
          return BidCard(
            item: item,
            onMakeBid: () {
              _showBidConfirmation(context, item);
            },
            onExplore: () {
              _showBidDetails(context, item);
            },
          );
        },
      ),
    );
  }

  void _showBidConfirmation(BuildContext context, BidItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Bid'),
          content:
              Text('Are you sure you want to bid on "${item.description}"?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Confirm Bid'),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bid placed successfully!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

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
                    '\$${item.maxAmount.toStringAsFixed(2)}',
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
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: onExplore,
                  child: Text('Explore'),
                ),
                ElevatedButton(
                  onPressed: onMakeBid,
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
  final String bidStatus;

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
    required this.bidStatus,
  });

  factory BidItem.fromJson(Map<String, dynamic> json) {
    return BidItem(
      bidId: json['bidId'],
      customerId: json['customerId'],
      serviceProviderId: json['serviceProviderId'],
      startBidTime: json['startBidTime'],
      endBidTime: json['endBidTime'],
      serviceTime: json['serviceTime'],
      category: json['category'],
      description: json['description'],
      maxAmount: (json['maxAmount'] as num).toDouble(),
      address: json['address'],
      state: json['state'],
      country: json['country'],
      additionalNotes: json['additionalNotes'],
      bidStatus: json['bidStatus'],
    );
  }
}
