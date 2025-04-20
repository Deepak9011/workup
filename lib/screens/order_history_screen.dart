import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/widgets/drawer.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          backgroundColor: AppColors.primary,
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
        drawer: const CustomDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: 4, // Replace with your real order data length
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order ID: ORD00${index + 1}",
                        style: AppTextStyles.textSmallBold),
                    const SizedBox(height: 6),
                    Text("Service: AC Installation",
                        style: AppTextStyles.textSmall),
                    const SizedBox(height: 6),
                    Text("Service Provider: Ramesh Ram",
                        style: AppTextStyles.textSmall),
                    const SizedBox(height: 6),
                    Text("Date: 08 Apr 2025",
                        style: AppTextStyles.textSmall
                            .merge(AppTextStyles.textMediumGrey)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount Charged: ₹800",
                            style: AppTextStyles.textSmallBold),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Completed",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/reviewFeedbackScreen');
                        },
                        child: const Text(
                          "Review",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
