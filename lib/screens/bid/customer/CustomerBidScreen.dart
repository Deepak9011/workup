import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workup/screens/bid/customer/CreateBidPageScreenCustomer.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';

class CustomerBidScreen extends StatefulWidget {
  final String customerId;

  const CustomerBidScreen({super.key, required this.customerId});

  @override
  State<CustomerBidScreen> createState() => _CustomerBidScreenState();
}

class _CustomerBidScreenState extends State<CustomerBidScreen> {
  String _filterStatus = 'All'; // 'All', 'Open', 'Closed'
  List<Map<String, dynamic>> bids = [];
  bool isLoading = true;
  String errorMessage = '';
  final String? apiBiddingUrl = dotenv.env['API_BIDDING_URL'];

  @override
  void initState() {
    super.initState();
    _fetchBids();
  }

  Future<void> _fetchBids() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$apiBiddingUrl/bids/customer/${widget.customerId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          bids = data.map((bid) {
            return {
              '_id': bid['bidId'],
              'customerId': bid['customerId'],
              'serviceProviderId': bid['serviceProviderId'],
              'startBidTime': bid['startBidTime'],
              'endBidTime': bid['endBidTime'],
              'serviceTime': bid['serviceTime'],
              'category': bid['category'],
              'description': bid['description'],
              'maxAmount': bid['maxAmount'],
              'address': bid['address'],
              'state': bid['state'],
              'country': bid['country'],
              'additionalNotes': bid['additionalNotes'],
              'bidStatus': bid['bidStatus'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to load bids. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching bids: $e';
      });
    }
  }

  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {}

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
          // Bids list or loading/error indicators
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (errorMessage.isNotEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _fetchBids,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredBids.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No bids found',
                  // style: AppTextStyles.subtitle,
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchBids,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80), // Padding for FAB
                  itemCount: filteredBids.length,
                  itemBuilder: (context, index) {
                    return BidDetailCard(
                      bidData: filteredBids[index],
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         BidDetailPage(bidData: filteredBids[index]),
                        //   ),
                        // );

                        Navigator.pushNamed(
                          context,
                          '/bidAcceptanceScreenCustomer',
                          arguments: {'bidId': filteredBids[index]['_id']},
                        );
                      },
                    );
                  },
                ),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateBidPageScreenCustomer(customerId: widget.customerId),
      ),
    ).then((_) {
      // Refresh bids after creating a new one
      _fetchBids();
    });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                Icons.description, 'Description:', bidData['description']),
            _buildDetailRow(Icons.category, 'Category:', bidData['category']),
            _buildDetailRow(
                Icons.calendar_today,
                'Service Time:',
                DateFormat('MMM dd, yyyy hh:mm a')
                    .format(DateTime.parse(bidData['serviceTime']))),
            _buildDetailRow(
                Icons.attach_money, 'Max Amount:', '${bidData['maxAmount']}'),
            _buildDetailRow(Icons.location_on, 'Address:',
                '${bidData['address']}, ${bidData['state']}, ${bidData['country']}'),
            _buildDetailRow(
                Icons.notes, 'Additional Notes:', bidData['additionalNotes']),
            const SizedBox(height: 20),
            Text(
              'Bid Status: ${bidData['bidStatus']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: bidData['bidStatus'] == 'Open'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value),
                const Divider(),
              ],
            ),
          ),
        ],
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
                      'Budget: ${bidData['maxAmount']?.toString() ?? 'N/A'}',
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
