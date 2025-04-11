import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BidDetailPage(
//         bidData: {
//           '_id': 'bid001',
//           'customerId': 'cust123',
//           'category': 'Plumbing',
//           'description': 'Fix kitchen sink leakage',
//           'serviceTime': DateTime.now().toIso8601String(),
//           'startBidTime': DateTime.now()
//               .subtract(const Duration(hours: 2))
//               .toIso8601String(),
//           'endBidTime':
//               DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
//           'maxAmount': 500,
//           'address': '221B Baker Street',
//           'state': 'London',
//           'country': 'UK',
//           'additionalNotes': 'Please bring proper tools.',
//           'image': {
//             'image1': 'sink1.jpg',
//             'image2': 'sink2.jpg',
//             'image3': null,
//             'image4': null,
//             'image5': null,
//           }
//         },
//       ),
//     ),
//   );
// }

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

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bid = widget.bidData;
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text('Bid Details - ${bid['category']}'),
        centerTitle: true,
      ),
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
                            labelText: 'Your Price (\$)',
                            prefixIcon: Icon(Icons.attach_money),
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
                            onPressed: _submitBid,
                            child: const Text('Submit Bid'),
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

  void _submitBid() {
    if (_formKey.currentState!.validate()) {
      final newBid = {
        'bidId': widget.bidData['_id'],
        'customerId': widget.bidData['customerId'],
        'price': double.parse(_priceController.text),
        'description': _descriptionController.text,
        'bidTime': DateTime.now().toIso8601String(),
      };

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Bid Submitted'),
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
  }
}
