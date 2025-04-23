import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/widgets/drawer.dart';
import 'package:workup/widgets/sp_bottom_navigation_bar.dart';

class ServiceProviderHomepageScreen extends StatefulWidget {
  const ServiceProviderHomepageScreen({super.key});

  @override
  State<ServiceProviderHomepageScreen> createState() => _ServiceProviderHomepageScreenState();
}

class _ServiceProviderHomepageScreenState extends State<ServiceProviderHomepageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Category> categoryData;

  final String? apiUrl = dotenv.env['API_BASE_URL'];

//   String jsonString = '''[
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     },
//     {
//         "imageURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
//         "text": "Electrician",
//         "category": "electrician"
//     }
// ]''';

  String jsonString = "";

  handleMenuClick() {
    _scaffoldKey.currentState?.openDrawer();
  }

  handleChatClick() {

  }

  Future<void> fetchData() async {

    final url = Uri.parse('$apiUrl/customers/getCategories'); // Replace with your URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the JSON response
        jsonString = response.body; // Get JSON as a raw string
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }

    try {
      List<dynamic> jsonData = jsonDecode(jsonString);
      categoryData = jsonData.map((item) => Category.fromJson(item)).toList();
      // Simulate a network request delay
      // await Future.delayed(const Duration(seconds: 3));

      // Simulate fetching data
      // You can replace this with actual data-fetching logic
      // e.g., var response = await http.get('https://api.example.com/data');
      // if (response.statusCode == 200) {
      //   return jsonDecode(response.body);
      // } else {
      //   throw Exception('Failed to load data');
      // }

      // For demonstration purposes, we'll just print a message
      // print('Content loaded successfully');
    } catch (e) {
      // Handle exceptions and errors
      // print('Error loading content: $e');
      rethrow; // Rethrow the exception to let FutureBuilder handle it
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
              Icons.menu_rounded,
              color: AppColors.white,
            ),
            onPressed: handleMenuClick,
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
        resizeToAvoidBottomInset: false,
        drawer: const CustomDrawer(),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(
                color: AppColors.primary,
              ));
            } else if(snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            } else{
              return Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of columns in the grid
                            crossAxisSpacing: 10.0, // Spacing between columns
                            mainAxisSpacing: 10.0, // Spacing between rows
                            childAspectRatio: 1.0, // Aspect ratio of each item
                          ),
                          itemCount: categoryData.length,
                          itemBuilder: (context, index) {
                            return categoryElement(categoryData[index].imageURL, categoryData[index].text, categoryData[index].category);
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }
          }
        ),
      ),
    );
  }

  Widget categoryElement(String imageURL, String text, String category) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
            context,
            '/serviceProviderListScreen',
          arguments: {
              'category': category
          }
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10), // Adjust radius as needed
        ),
        width: 100.0,
        height: 100.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
                child: SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: Image.network(
                      imageURL,
                      fit: BoxFit.cover
                  ),
                )
            ),
            Expanded(
                child: Center(
                    child: Text(
                        text,
                      style: AppTextStyles.text2.merge(AppTextStyles.textWhite),
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}

class Category{
  final String imageURL;
  final String text;
  final String category;

  Category({
    required this.imageURL,
    required this.text,
    required this.category,
  });

  // Factory method to create a Service object from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      imageURL: json['image_url'],
      text: json['category_name'],
      category: json['category_id'],
    );
  }
}

