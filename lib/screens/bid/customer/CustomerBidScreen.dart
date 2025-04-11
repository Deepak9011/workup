import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';

class CustomerBidScreen extends StatefulWidget {
  const CustomerBidScreen({super.key});

  @override
  State<CustomerBidScreen> createState() => _CustomerBidScreenState();
}

class _CustomerBidScreenState extends State<CustomerBidScreen> {
  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {}

  String _filterStatus = 'All'; // 'All', 'Open', 'Closed'

  // Sample bid data
  final List<Map<String, dynamic>> bids = [
    {
      '_id': '67f21bb7bcdcdc16621572ce',
      'customerId': 'cust123',
      'serviceProviderId': 'provider456',
      'startBidTime': '2023-06-15T03:30:00.000+00:00',
      'endBidTime': '2023-06-20T11:30:00.000+00:00',
      'serviceTime': '2023-06-25T04:30:00.000+00:00',
      'category': 'Plumbing',
      'description': 'Fix leaking kitchen sink',
      'maxAmount': 150,
      'address': '123 Main St',
      'state': 'California',
      'country': 'USA',
      'additionalNotes': 'Available on weekends',
      'bidStatus': 'Open',
    },
    {
      '_id': '68g32cc8cdeced27732683df',
      'customerId': 'cust456',
      'serviceProviderId': 'provider789',
      'startBidTime': '2023-06-10T08:00:00.000+00:00',
      'endBidTime': '2023-06-15T17:00:00.000+00:00',
      'serviceTime': '2023-06-18T09:00:00.000+00:00',
      'category': 'Electrical',
      'description': 'Install new ceiling lights',
      'maxAmount': 300,
      'address': '456 Oak Ave',
      'state': 'New York',
      'country': 'USA',
      'additionalNotes': 'Need licensed electrician',
      'bidStatus': 'Closed',
    },
    {
      '_id': '67f21bb7bcdcdc16621572ce',
      'customerId': 'cust123',
      'serviceProviderId': 'provider456',
      'startBidTime': '2023-06-15T03:30:00.000+00:00',
      'endBidTime': '2023-06-20T11:30:00.000+00:00',
      'serviceTime': '2023-06-25T04:30:00.000+00:00',
      'category': 'Plumbing',
      'description': 'Fix leaking kitchen sink',
      'maxAmount': 150,
      'address': '123 Main St',
      'state': 'California',
      'country': 'USA',
      'additionalNotes': 'Available on weekends',
      'bidStatus': 'Open',
    },
    {
      '_id': '68g32cc8cdeced27732683df',
      'customerId': 'cust456',
      'serviceProviderId': 'provider789',
      'startBidTime': '2023-06-10T08:00:00.000+00:00',
      'endBidTime': '2023-06-15T17:00:00.000+00:00',
      'serviceTime': '2023-06-18T09:00:00.000+00:00',
      'category': 'Electrical',
      'description': 'Install new ceiling lights',
      'maxAmount': 300,
      'address': '456 Oak Ave',
      'state': 'New York',
      'country': 'USA',
      'additionalNotes': 'Need licensed electrician',
      'bidStatus': 'Closed',
    },
    {
      '_id': '67f21bb7bcdcdc16621572ce',
      'customerId': 'cust123',
      'serviceProviderId': 'provider456',
      'startBidTime': '2023-06-15T03:30:00.000+00:00',
      'endBidTime': '2023-06-20T11:30:00.000+00:00',
      'serviceTime': '2023-06-25T04:30:00.000+00:00',
      'category': 'Plumbing',
      'description': 'Fix leaking kitchen sink',
      'maxAmount': 150,
      'address': '123 Main St',
      'state': 'California',
      'country': 'USA',
      'additionalNotes': 'Available on weekends',
      'bidStatus': 'Open',
    },
    {
      '_id': '68g32cc8cdeced27732683df',
      'customerId': 'cust456',
      'serviceProviderId': 'provider789',
      'startBidTime': '2023-06-10T08:00:00.000+00:00',
      'endBidTime': '2023-06-15T17:00:00.000+00:00',
      'serviceTime': '2023-06-18T09:00:00.000+00:00',
      'category': 'Electrical',
      'description': 'Install new ceiling lights',
      'maxAmount': 300,
      'address': '456 Oak Ave',
      'state': 'New York',
      'country': 'USA',
      'additionalNotes': 'Need licensed electrician',
      'bidStatus': 'Closed',
    },
    {
      '_id': '67f21bb7bcdcdc16621572ce',
      'customerId': 'cust123',
      'serviceProviderId': 'provider456',
      'startBidTime': '2023-06-15T03:30:00.000+00:00',
      'endBidTime': '2023-06-20T11:30:00.000+00:00',
      'serviceTime': '2023-06-25T04:30:00.000+00:00',
      'category': 'Plumbing',
      'description': 'Fix leaking kitchen sink',
      'maxAmount': 150,
      'address': '123 Main St',
      'state': 'California',
      'country': 'USA',
      'additionalNotes': 'Available on weekends',
      'bidStatus': 'Open',
    },
    {
      '_id': '68g32cc8cdeced27732683df',
      'customerId': 'cust456',
      'serviceProviderId': 'provider789',
      'startBidTime': '2023-06-10T08:00:00.000+00:00',
      'endBidTime': '2023-06-15T17:00:00.000+00:00',
      'serviceTime': '2023-06-18T09:00:00.000+00:00',
      'category': 'Electrical',
      'description': 'Install new ceiling lights',
      'maxAmount': 300,
      'address': '456 Oak Ave',
      'state': 'New York',
      'country': 'USA',
      'additionalNotes': 'Need licensed electrician',
      'bidStatus': 'Closed',
    },
    // ... (rest of your bid data)
  ];

  List<Map<String, dynamic>> get filteredBids {
    if (_filterStatus == 'All') return bids;
    return bids.where((bid) => bid['bidStatus'] == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Center(
            child: Text(
          "Available Bids",
          style: AppTextStyles.title.merge(AppTextStyles.textWhite),
        )),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.white,
          ),
          onPressed: handleBackClick,
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
      body: Column(
        children: [
          // Filter buttons row
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('All'),
                _buildFilterButton('Open'),
                _buildFilterButton('Closed'),
              ],
            ),
          ),
          const Divider(height: 1),
          // Bids list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80), // Padding for FAB
              itemCount: filteredBids.length,
              itemBuilder: (context, index) {
                return BidDetailCard(
                  bidData: filteredBids[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BidDetailPage(bidData: filteredBids[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () => _showCreateBidDialog(context),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label:
              const Text('Create Bid', style: TextStyle(color: Colors.white)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFilterButton(String status) {
    final isSelected = _filterStatus == status;
    return OutlinedButton(
      onPressed: () => setState(() => _filterStatus = status),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
        side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }

  void _showCreateBidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Bid'),
        content: const Text('This would open a form to create a new bid.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New bid created!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Create', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class BidDetailPage extends StatelessWidget {
  final Map<String, dynamic> bidData;

  const BidDetailPage({Key? key, required this.bidData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bidData['category']),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text('Details for ${bidData['description']}'),
      ),
    );
  }
}

class BidDetailCard extends StatelessWidget {
  final Map<String, dynamic> bidData;
  final VoidCallback onTap;

  const BidDetailCard({
    Key? key,
    required this.bidData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
    final status = bidData['bidStatus']?.toString() ?? 'Open';
    final backgroundColor =
        status.toLowerCase() == 'open' ? Colors.green[50] : Colors.orange[50];

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: status.toLowerCase() == 'open'
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          bidData['category'] ?? 'No Category',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bidData['description'] ?? 'No Description',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Service: ${dateFormat.format(DateTime.parse(bidData['serviceTime']))}',
                      context,
                    ),
                    _buildDetailRow(
                      Icons.attach_money,
                      'Budget: \$${bidData['maxAmount']?.toString() ?? 'N/A'}',
                      context,
                    ),
                    _buildDetailRow(
                      Icons.location_on,
                      '${bidData['address']}, ${bidData['state']}, ${bidData['country']}',
                      context,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.mediumGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkGrey,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:workup/utils/colors.dart';
// import 'package:workup/utils/strings.dart';
// import 'package:workup/utils/text_styles.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:workup/widgets/bottom_navigation_bar.dart';
// import 'package:workup/widgets/drawer.dart';

// class CustomerBidScreen extends StatefulWidget {
//   const CustomerBidScreen({super.key});

//   @override
//   State<CustomerBidScreen> createState() => _CustomerBidScreenState();
// }

// class _CustomerBidScreenState extends State<CustomerBidScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   @override
//   void dispose() {
//     _priceController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bid = widget.bidData;
//     final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bid Details - ${bid['category']}'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Service Details Section
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       bid['category'],
//                       style: Theme.of(context).textTheme.headline6,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       bid['description'],
//                       style: Theme.of(context).textTheme.bodyText1,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildDetailRow(Icons.calendar_today,
//                         'Service Date: ${dateFormat.format(DateTime.parse(bid['serviceTime']))}'),
//                     _buildDetailRow(Icons.timer,
//                         'Bidding Open: ${dateFormat.format(DateTime.parse(bid['startBidTime']))}'),
//                     _buildDetailRow(Icons.timer_off,
//                         'Bidding Closes: ${dateFormat.format(DateTime.parse(bid['endBidTime']))}'),
//                     _buildDetailRow(Icons.attach_money,
//                         'Maximum Budget: \$${bid['maxAmount']}'),
//                     _buildDetailRow(Icons.location_on,
//                         'Location: ${bid['address']}, ${bid['state']}, ${bid['country']}'),
//                     if (bid['additionalNotes'] != null &&
//                         bid['additionalNotes'].isNotEmpty)
//                       _buildDetailRow(
//                           Icons.note, 'Notes: ${bid['additionalNotes']}'),
//                   ],
//                 ),
//               ),
//             ),

//             // Images Section
//             if (bid.containsKey('image') && bid['image'] is Map)
//               Padding(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Attached Images:',
//                       style: Theme.of(context).textTheme.subtitle1,
//                     ),
//                     const SizedBox(height: 8),
//                     SizedBox(
//                       height: 120,
//                       child: ListView(
//                         scrollDirection: Axis.horizontal,
//                         children: [
//                           for (var i = 1; i <= 5; i++)
//                             if (bid['image']['image$i'] != null)
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Container(
//                                     width: 120,
//                                     height: 120,
//                                     color: Colors.grey[200],
//                                     child: Center(
//                                       child: Icon(Icons.image,
//                                           size: 40, color: Colors.grey[400]),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//             // Place Bid Section
//             Padding(
//               padding: const EdgeInsets.only(top: 24.0),
//               child: Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Place Your Bid',
//                           style: Theme.of(context).textTheme.headline6,
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _priceController,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: 'Your Price (\$)',
//                             prefixIcon: Icon(Icons.attach_money),
//                             border: OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your bid amount';
//                             }
//                             if (double.tryParse(value) == null) {
//                               return 'Please enter a valid number';
//                             }
//                             if (double.parse(value) > bid['maxAmount']) {
//                               return 'Amount exceeds customer\'s maximum budget';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _descriptionController,
//                           maxLines: 3,
//                           decoration: const InputDecoration(
//                             labelText: 'Description (Optional)',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                             ),
//                             onPressed: _submitBid,
//                             child: const Text('Submit Bid'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Existing Bids Section
//             Padding(
//               padding: const EdgeInsets.only(top: 24.0),
//               child: Text(
//                 'Your Previous Bids',
//                 style: Theme.of(context).textTheme.subtitle1,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 20, color: Colors.grey),
//           const SizedBox(width: 8),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }

//   void _submitBid() {
//     if (_formKey.currentState!.validate()) {
//       final newBid = {
//         'bidId': widget.bidData['_id'],
//         'customerId': widget.bidData['customerId'],
//         'price': double.parse(_priceController.text),
//         'description': _descriptionController.text,
//         'bidTime': DateTime.now().toIso8601String(),
//       };

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Bid Submitted'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Amount: \$${newBid['price']}'),
//               if (newBid['description'] != null &&
//                   newBid['description'].isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text('Note: ${newBid['description']}'),
//                 ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
