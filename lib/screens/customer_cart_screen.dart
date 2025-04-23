import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({super.key});

  @override
  _CustomerCartScreenState createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  double travellingFee = 79;
  double platformFee = 79;
  double gst = 79;
  bool isLoading = true;

  List<int> quantities = List.generate(5, (index) => 0);
  List<double> itemPrices = List.generate(5, (index) => 79.0);

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  double calculateTotal() {
    double itemsTotal = 0;
    for (int i = 0; i < quantities.length; i++) {
      itemsTotal += quantities[i] * itemPrices[i];
    }
    return itemsTotal + travellingFee + platformFee + gst;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void handleChatClick() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: Center(
          child: Text(
            AppStrings.appTitle,
            style: AppTextStyles.title.merge(AppTextStyles.textWhite),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat_rounded,
              color: AppColors.white,
            ),
            onPressed: handleChatClick,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: quantities.length,
                itemBuilder: (context, index) {
                  int itemQuantity = quantities[index];
                  double priceForItem = itemQuantity * itemPrices[index];

                  return Card(
                    color: AppColors.secondary,
                    child: ListTile(
                      title: const Text(
                        "Light installation",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            color: AppColors.white,
                            onPressed: () {
                              setState(() {
                                if (quantities[index] > 0) {
                                  quantities[index]--;
                                }
                              });
                            },
                          ),
                          Text(
                            '$itemQuantity',
                            style: TextStyle(color: AppColors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            color: AppColors.white,
                            onPressed: () {
                              setState(() {
                                quantities[index]++;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 70, // Increased width for alignment
                            child: Text(
                              '₹${priceForItem.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'OFFERS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "HAPPY DIWALI",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "Save ₹99 on this order",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Item Total',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  buildBillRow("Item Total", quantities.asMap().entries.map((entry) => entry.value * itemPrices[entry.key]).reduce((a, b) => a + b)),
                  buildBillRow("Travelling Fee", travellingFee),
                  buildBillRow("Platform Fee", platformFee),
                  buildBillRow("GST", gst),
                  const Divider(color: AppColors.primary),
                  buildBillRow("To Pay", calculateTotal(), isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget buildBillRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(
            width: 70, // Adjusted width for consistent alignment
            child: Text(
              '₹${amount.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
