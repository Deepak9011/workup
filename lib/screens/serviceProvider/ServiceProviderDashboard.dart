import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceProviderDashboard extends StatefulWidget {
  @override
  _ServiceProviderDashboardState createState() =>
      _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends State<ServiceProviderDashboard> {
  final String customerId = 'cust123deepak';
  List<dynamic> bids = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchBids();
  }

  Future<void> fetchBids() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://workup-bidding-module.onrender.com/bidded/customer/$customerId'));

      if (response.statusCode == 200) {
        setState(() {
          bids = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load bids');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Dashboard'),
      ),
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
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceProviderBidDetailScreen()));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate to bid creation screen')));
            },
            child: Text('Make a Bid'),
          ),
        );
      case 3:
        return Center(child: Text('About Content'));
      default:
        return Container();
    }
  }

  Widget _buildAllBidsTab() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
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
            title: Text('\$${bid['price']}'),
            subtitle: Text(bid['description']),
            trailing: Text(bid['status']),
            onTap: () {
              // Show bid details or navigate to detail screen
              _showBidDetails(bid);
            },
          ),
        );
      },
    );
  }

  void _showBidDetails(Map<String, dynamic> bid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bid Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${bid['price']}'),
            SizedBox(height: 8),
            Text('Description: ${bid['description']}'),
            SizedBox(height: 8),
            Text('Status: ${bid['status']}'),
            SizedBox(height: 8),
            Text('Bid Time: ${bid['bidTime']}'),
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
