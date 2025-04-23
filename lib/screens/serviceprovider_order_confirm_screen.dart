import 'package:flutter/material.dart';
import 'package:workup/services/cart_service.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/widgets/drawer.dart';

class ServiceProviderOrderConfirmScreen extends StatefulWidget {
  const ServiceProviderOrderConfirmScreen({super.key});

  @override
  State<ServiceProviderOrderConfirmScreen> createState() => _ServiceProviderOrderConfirmScreenState();
}

class _ServiceProviderOrderConfirmScreenState extends State<ServiceProviderOrderConfirmScreen> {
  final CartState cartState = CartState();
  final String apiUrl = "https://example.com/api"; // Replace with actual API URL
  List<Map<String, List<Map<String, int>>>> subcategories = [];
  Map<String, dynamic> sp = {};

  Future<void> fetchData() async {
    try {
      final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        setState(() {
          subcategories = List<Map<String, List<Map<String, int>>>>.from(args["data"]);
          sp = args["sp"];
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {

  }

  void placeOrder() {
    final orderData = cartState.getJson();
    print("Order Data: $orderData");
    // Implement order submission logic
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
              child: Text(
                AppStrings.appTitle,
                style: AppTextStyles.title.merge(AppTextStyles.textWhite),
              )
          ),
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
        resizeToAvoidBottomInset: false,
        drawer: const CustomDrawer(),
        body: FutureBuilder<void>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: subcategories.length,
                      itemBuilder: (context, subIndex) {
                        String subcategoryId = subcategories[subIndex].keys.first;
                        List<Map<String, int>> tasks = subcategories[subIndex][subcategoryId]!;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subcategoryId,
                                  style: AppTextStyles.textSmall
                                      .merge(AppTextStyles.textMediumGrey),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  children: tasks.map((task) {
                                    String taskId = task.keys.first;
                                    int taskValue = task[taskId]!; // Assuming int values

                                    return ListTile(
                                      title: Text(taskId),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(cartState.getQuantity(subcategoryId, taskId).toString()),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: placeOrder,
                      child: Text("Place Order", style: AppTextStyles.textWhite),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}