import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/services/cart_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> staticOrders = [
      {
        'orderId': 'ORD001',
        'service': 'Clothes Washing',
        'provider': 'Seema Verma',
        'date': '12 Apr 2025',
        'amount': '₹350',
        'status': 'Completed',
      },
      {
        'orderId': 'ORD002',
        'service': 'Kitchen Deep Cleaning',
        'provider': 'Ankit Sharma',
        'date': '10 Apr 2025',
        'amount': '₹700',
        'status': 'Completed',
      },
    ];

    final List<Map<String, dynamic>> dynamicOrders =
        CartState().getFlatTaskList().map((task) {
      return {
        'orderId': 'ORD${100 + task.hashCode % 900}',
        'service': task['name'],
        'provider': 'Demo Provider',
        'date': '17 Apr 2025',
        'amount': '₹${(task['price'] * task['qty']).toStringAsFixed(0)}',
        'status': 'Completed',
      };
    }).toList();

    final List<Map<String, dynamic>> allOrders = [
      ...staticOrders,
      ...dynamicOrders
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Center(
            child: Text("Order History",
                style: AppTextStyles.title.merge(AppTextStyles.textWhite)),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.chat, color: AppColors.white),
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: allOrders.length,
          itemBuilder: (context, index) {
            final order = allOrders[index];
            return buildOrderCard(order, context);
          },
        ),
      ),
    );
  }

  Widget buildOrderCard(Map<String, dynamic> order, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order['orderId']}",
                style: AppTextStyles.textSmallBold),
            const SizedBox(height: 6),
            Text("Service: ${order['service']}",
                style: AppTextStyles.textSmall),
            const SizedBox(height: 6),
            Text("Service Provider: ${order['provider']}",
                style: AppTextStyles.textSmall),
            const SizedBox(height: 6),
            Text("Date: ${order['date']}",
                style: AppTextStyles.textSmall
                    .merge(AppTextStyles.textMediumGrey)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount Charged: ${order['amount']}",
                    style: AppTextStyles.textSmallBold),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: order['status'] == 'Completed'
                        ? Colors.green
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(order['status'],
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/reviewFeedbackScreen');
                },
                child:
                    const Text("Review", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
