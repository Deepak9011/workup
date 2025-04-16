import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:workup/widgets/sp_bottom_navigation_bar.dart';

class ServiceProviderBidDetailScreen extends StatefulWidget {
  final Map<String, dynamic> bidData;

  const ServiceProviderBidDetailScreen({Key? key, required this.bidData})
      : super(key: key);

  @override
  _ServiceProviderBidDetailScreenState createState() =>
      _ServiceProviderBidDetailScreenState();
}

class _ServiceProviderBidDetailScreenState
    extends State<ServiceProviderBidDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  final String? apiBiddingUrl = dotenv.env['API_BIDDING_URL'];

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {}

  Future<void> _submitBid() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final newBid = {
          "bidId": widget.bidData['_id'],
          "customerId": widget.bidData['customerId'],
          "price": double.parse(_priceController.text),
          "description": _descriptionController.text,
        };

        final response = await http.post(
          Uri.parse('$apiBiddingUrl/bidded'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(newBid),
        );

        setState(() {
          _isSubmitting = false;
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Success
          _showSuccessDialog(newBid);
        } else {
          // Error
          _showErrorDialog(
              'Failed to submit bid. Server responded with ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        _showErrorDialog('An error occurred: ${e.toString()}');
      }
    }
  }

  void _showSuccessDialog(Map<String, dynamic> newBid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bid Submitted Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: \$${newBid['price']}'),
            if (newBid['description'] != null &&
                newBid['description'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Note: ${newBid['description']}'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bid = widget.bidData;
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Center(
            child: Text(
          "Bid Details Page",
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
      bottomNavigationBar: const SPCustomBottomNavigationBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Details Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid['category'],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bid['description'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.calendar_today,
                        'Service Date: ${dateFormat.format(DateTime.parse(bid['serviceTime']))}'),
                    _buildDetailRow(Icons.timer,
                        'Bidding Open: ${dateFormat.format(DateTime.parse(bid['startBidTime']))}'),
                    _buildDetailRow(Icons.timer_off,
                        'Bidding Closes: ${dateFormat.format(DateTime.parse(bid['endBidTime']))}'),
                    _buildDetailRow(Icons.attach_money,
                        'Maximum Budget: \$${bid['maxAmount']}'),
                    _buildDetailRow(Icons.location_on,
                        'Location: ${bid['address']}, ${bid['state']}, ${bid['country']}'),
                    if (bid['additionalNotes'] != null &&
                        bid['additionalNotes'].isNotEmpty)
                      _buildDetailRow(
                          Icons.note, 'Notes: ${bid['additionalNotes']}'),
                  ],
                ),
              ),
            ),

            // Images Section
            if (bid.containsKey('image') && bid['image'] is Map)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attached Images:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var i = 1; i <= 5; i++)
                            if (bid['image']['image$i'] != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Icon(Icons.image,
                                          size: 40, color: Colors.grey[400]),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Place Bid Section
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Place Your Bid',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Your Price ',
                            prefixIcon: Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your bid amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            if (double.parse(value) > bid['maxAmount']) {
                              return 'Amount exceeds customer\'s maximum budget';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: _isSubmitting ? null : _submitBid,
                            child: _isSubmitting
                                ? const CircularProgressIndicator()
                                : const Text('Submit Bid'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Existing Bids Section
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                'Your Previous Bids',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:workup/utils/colors.dart';
// import 'package:workup/utils/text_styles.dart';
// import 'package:workup/widgets/bottom_navigation_bar.dart';

// class ServiceProviderBidDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> bidData;

//   const ServiceProviderBidDetailScreen({Key? key, required this.bidData})
//       : super(key: key);

//   @override
//   _ServiceProviderBidDetailScreenState createState() =>
//       _ServiceProviderBidDetailScreenState();
// }

// class _ServiceProviderBidDetailScreenState
//     extends State<ServiceProviderBidDetailScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   @override
//   void dispose() {
//     _priceController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   handleBackClick() {
//     Navigator.pop(context);
//   }

//   handleChatClick() {}

//   @override
//   Widget build(BuildContext context) {
//     final bid = widget.bidData;
//     final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: Center(
//             child: Text(
//           "Bid Details Page",
//           style: AppTextStyles.title.merge(AppTextStyles.textWhite),
//         )),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_rounded,
//             color: AppColors.white,
//           ),
//           onPressed: handleBackClick,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.chat_rounded,
//               color: AppColors.white,
//             ),
//             onPressed: handleChatClick,
//           )
//         ],
//       ),
//       bottomNavigationBar: const CustomBottomNavigationBar(),
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
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       bid['description'],
//                       style: Theme.of(context).textTheme.bodyLarge,
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
//                       style: Theme.of(context).textTheme.titleMedium,
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
//                           style: Theme.of(context).textTheme.titleLarge,
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
//                 style: Theme.of(context).textTheme.titleMedium,
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
