import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/widgets/drawer.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String customerId;
  final String providerId;
  final String service;
  final int amount;

  const OrderConfirmationScreen({
    super.key,
    required this.customerId,
    required this.providerId,
    required this.service,
    required this.amount,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String? orderId;
  String? confirmedOn;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    confirmOrder(); // Trigger backend call
  }

  Future<void> confirmOrder() async {
    final url = Uri.parse('https://your-api-url/orders/confirmOrder'); // 👈 replace with actual backend URL

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "customerId": widget.customerId,
          "providerId": widget.providerId,
          "service": widget.service,
          "amount": widget.amount,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          orderId = data['orderId'];
          confirmedOn = DateFormat('dd MMM yyyy, hh:mm a')
              .format(DateTime.parse(data['confirmedOn']));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to confirm order');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
            child: Text("Order Confirmation",
                style: AppTextStyles.title.merge(AppTextStyles.textWhite)),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                "Order Confirmed!",
                style: AppTextStyles.title.merge(AppTextStyles.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "Your order has been placed successfully.",
                style: AppTextStyles.textSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              buildDetailRow("Order ID", orderId ?? "Loading..."),
              buildDetailRow("Service", widget.service),
              buildDetailRow("Provider", widget.providerId),
              buildDetailRow("Total Amount", "₹${widget.amount}"),
              buildDetailRow("Confirmed On", confirmedOn ?? "Loading..."),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/orderHistoryScreen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 16),
                ),
                child: const Text("View My Orders",
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text("Back to Home"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.textSmallBold),
          Text(value, style: AppTextStyles.textSmall),
        ],
      ),
    );
  }
}