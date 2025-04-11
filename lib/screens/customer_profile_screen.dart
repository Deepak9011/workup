import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/secure_storage.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/widgets/drawer.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ServiceProviderInfo serviceProviderData;
  final String? apiUrl = dotenv.env['API_BASE_URL'];

  String? sID;

  String jsonString = "";
  late Map<String,dynamic> jsonData;

  String jsonString2 = '''[
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    },
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    },
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    },
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    },
    {
      "name": "Light",
      "tasks": [
        {
          "task_name": "Light replacement",
          "price": 100
        },
        {
          "task_name": "Light installation",
          "price": 80
        }
      ]
    }
  ]''';

  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {

  }

  handleFilterClick(){

  }

  editProfileClick(){
    Navigator.pushNamed(
        context,
        '/customerEditProfileScreen',
        arguments: jsonData
    );
  }

  saveClickHandler(bool saved, String sID){

  }

  logOutSPClick() async {
    await deleteType();
    await deleteToken();
    await deleteEmail();
    await deletePassword();
    Navigator.pushReplacementNamed(context, '/loginScreen');
  }

  Future<void> fetchData() async {
    try {
      var email = await getEmail();

      final url1 = Uri.parse('$apiUrl/customers/getCustomerDetails'); // Replace with your URL

      try {
        final response = await http.post(
          url1,
          headers: {'Content-Type': 'application/json'}, // Optional headers
          body: '{"email": "$email"}',
        );

        if (response.statusCode == 200) {
          // Decode the JSON response
          jsonString = response.body; // Get JSON as a raw string
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }

      jsonData = jsonDecode(jsonString);
      serviceProviderData = ServiceProviderInfo.fromJson(jsonData);

      List<dynamic> jsonData2 = jsonDecode(jsonString2);

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
        drawer: const CustomDrawer(),
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColors.white, // Change to your desired color
          ),
          backgroundColor: AppColors.primary,
          title: Center(
              child: Text(
                AppStrings.appTitle,
                style: AppTextStyles.title.merge(AppTextStyles.textWhite),
              )
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
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        serviceProviderInfo(serviceProviderData.imgURL, serviceProviderData.sID, serviceProviderData.sName, serviceProviderData.category, serviceProviderData.newSProvider, serviceProviderData.rating, serviceProviderData.reviews, serviceProviderData.ordersCompleted, serviceProviderData.away),
                        const SizedBox(height: 20.0),
                        Column(
                          children: List.generate(5 * 2 - 1, (index) {
                            if (index.isEven) {
                              int itemIndex = index ~/ 2;
                              return const SizedBox(height: 100, width: double.infinity);
                            } else {
                              return const SizedBox(height: 20.0); // Spacing between items
                            }
                          }),
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

  Widget serviceProviderInfo(String imgURL, String sID, String sName, String category, bool newSProvider, double rating, int reviews, int ordersCompleted, double away) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 80,
                height: 80,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(imgURL),
                ),
              ),
            )
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    sName,
                    style: AppTextStyles.text2,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: ShapeDecoration(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (newSProvider)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Text(
                              AppStrings.newSeller,
                              style: AppTextStyles.textSmallBold
                                  .merge(AppTextStyles.textWhite),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: AppTextStyles.textSmall
                        .merge(AppTextStyles.textMediumGrey),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              FittedBox(
                child: GestureDetector(
                  onTap: (){
                    editProfileClick();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),  // Rounded corners with radius of 12
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            AppStrings.editProfile,
                            style: AppTextStyles.text2.merge(AppTextStyles.textWhite),
                          ),
                          const SizedBox(width: 10,),
                          const Icon(
                            Icons.arrow_right,
                            color: AppColors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: AppColors.primary, size: 16.0),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: AppTextStyles.text2.merge(AppTextStyles.textPrimary),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${reviews.toString()})',
                  style: AppTextStyles.textExtraSmall.merge(AppTextStyles.textMediumGrey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  ordersCompleted.toString(),
                  style: AppTextStyles.text2.merge(AppTextStyles.textPrimary),
                ),
                const SizedBox(width: 4),
                Text(
                  AppStrings.orders,
                  style: AppTextStyles.textExtraSmall
                      .merge(AppTextStyles.textMediumGrey),
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  away.toString(),
                  style: AppTextStyles.text2.merge(AppTextStyles.textPrimary),
                ),
                const SizedBox(width: 4),
                Text(
                  AppStrings.km,
                  style: AppTextStyles.textExtraSmall
                      .merge(AppTextStyles.textMediumGrey),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget getNewTag(bool newSProvider){
    if(newSProvider){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: ShapeDecoration(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Center(
          child: Text(
              AppStrings.newSeller,
              style: AppTextStyles.textSmallBold.merge(AppTextStyles.textWhite)
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class ServiceProviderInfo {
  final String imgURL;
  final String sID;
  final String sName;
  final String category;
  final bool newSProvider;
  final double rating;
  final int reviews;
  final int ordersCompleted;
  final double away;
  ServiceProviderInfo({
    required this.imgURL,
    required this.sID,
    required this.sName,
    required this.category,
    required this.newSProvider,
    required this.rating,
    required this.reviews,
    required this.ordersCompleted,
    required this.away,
  });
  factory ServiceProviderInfo.fromJson(Map<String, dynamic> json) {
    return ServiceProviderInfo(
      imgURL: json['imgUrl'],
      sID: json['uuid'],
      sName: json['firstName'],
      category: json['lastName'],
      newSProvider: true,
      rating: json['zipCode'].toDouble(),
      reviews: json['zipCode'],
      ordersCompleted: json['zipCode'],
      away: json['zipCode'].toDouble(),
    );
  }
}