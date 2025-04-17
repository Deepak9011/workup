import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';

class ReviewFeedbackScreen extends StatefulWidget {
  const ReviewFeedbackScreen({super.key});

  @override
  State<ReviewFeedbackScreen> createState() => _ReviewFeedbackScreenState();
}

class _ReviewFeedbackScreenState extends State<ReviewFeedbackScreen> {
  int rating = 0;
  final TextEditingController reviewController = TextEditingController();
  final List<String> selectedTags = [];

  final List<String> tags = [
    "Punctuality",
    "Service Provider's behavior",
    "Quality of service"
  ];

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Center(
          child: Icon(Icons.check_circle, color: Colors.green, size: 60),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "Review Submitted!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text("Thank you for your feedback.", textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String orderId = args?['orderId'] ?? 'N/A';
    final String service = args?['service'] ?? 'N/A';
    final String provider = args?['provider'] ?? 'N/A';
    final String amount = args?['amount'] ?? 'N/A';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          title: Center(
            child: Text("Review & Feedback",
                style: AppTextStyles.title.merge(AppTextStyles.textWhite)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order ID: $orderId"),
                const SizedBox(height: 8),
                Text("Service: $service"),
                const SizedBox(height: 8),
                Text("Service Provider: $provider"),
                const SizedBox(height: 8),
                Text("Amount Charged: $amount"),
                const SizedBox(height: 20),
                const Text("Overall Service Rating:"),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: index < rating ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                const Text("What did you like?"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: tags.map((tag) {
                    final isSelected = selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text("Write a Review:"),
                const SizedBox(height: 8),
                TextField(
                  controller: reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Share your experience...",
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                    ),
                    onPressed: () {
                      showSuccessDialog();
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
