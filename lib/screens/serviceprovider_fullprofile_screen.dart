import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';

class ServiceProviderFullProfileScreen extends StatefulWidget {
  const ServiceProviderFullProfileScreen({super.key});

  @override
  State<ServiceProviderFullProfileScreen> createState() =>
      _ServiceProviderFullProfileScreenState();
}

class _ServiceProviderFullProfileScreenState extends State<ServiceProviderFullProfileScreen> {

  Map<String, dynamic> spData = {}; // <-- Here!

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // late List<BasicInfoBox> basicInfoData = [];// late List<ServiceProviderBioBox> serviceProviderBioData = [];// late List<FeaturedBox> featuredImages = [];// late List<LanguagesBox> languagesKnown = [];// late List<ServiceProviderReviewBox> spReviews = [];

  final String? apiUrl = dotenv.env['API_BASE_URL'];

  String jsonString = '';
  // '''[
  // {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "suman",
  //     "sName": "Suman Debnath",
  //     "category": "Electrician",
  //     "newSProvider": true,
  //     "rating": 4.5,
  //     "reviews": 20,
  //     "ordersCompleted": 210,
  //     "away": 3.5
  // },
  // {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "aniket",
  //     "sName": "Aniket Bandi",
  //     "category": "Plumber",
  //     "newSProvider": false,
  //     "rating": 4.0,
  //     "reviews": 250,
  //     "ordersCompleted": 590,
  //     "away": 3.9
  // },
  // {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "suman1",
  //     "sName": "Suman Debnath",
  //     "category": "Electrician",
  //     "newSProvider": true,
  //     "rating": 4.5,
  //     "reviews": 20,
  //     "ordersCompleted": 210,
  //     "away": 3.5
  // },
  // {
  //     "imgURL": "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-4.jpg",
  //     "sID": "aniket1",
  //     "sName": "Aniket Bandi",
  //     "category": "Plumber",
  //     "newSProvider": false,
  //     "rating": 4.0,
  //     "reviews": 250,
  //     "ordersCompleted": 590,
  //     "away": 3.9
  // }
  // ]''';

  String jsonString2 = '';
  // '''[
  // {
  //   "sID": "suman",
  //   "bio": "Suman Bio: Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
  // },
  // {
  //   "sID": "aniket",
  //   "bio": "Aniket Bio: Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
  // },
  // {
  //   "sID": "suman1",
  //   "bio": "Suman1 Bio: Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
  // },
  // {
  //   "sID": "aniket1",
  //   "bio": "Aniket1 Bio: Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
  // }
  // ]''';

  String jsonString3 = '';
  // '''[
  // {
  // "sID": "suman",
  // "images": [
  //         "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-2.jpg",
  //         "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-2.jpg",
  //         "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-2.jpg"
  // ]
  // },
  // {
  //   "sID": "aniket",
  //   "images": [
  //         "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-3.jpg",
  //         "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-3.jpg",
  //         "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-3.jpg",
  //         "https://res.cloudinary.com/deeqsba43/image/upload/v1691336265/cld-sample-3.jpg"
  //
  // ]
  // }
  // ]''';

  String jsonString4 = '';
  // '''[
  // {
  //     "sID": "suman",
  //     "languages": [
  //         "English",
  //         "Hindi",
  //         "Bengali"]
  // },
  // {
  // "sID": "aniket",
  //     "languages": [
  //         "English",
  //         "Hindi"]
  // }
  // ]''';

  String jsonString5 ='';
  // '''[
  // {
  //   "sID": "suman",
  //   "reviews": [
  //   {
  //       "reviewer": "Aayushi Sahay Shrivastava",
  //       "profilePhotoURL": "https://img.freepik.com/premium-photo/side-view-woman-holding-hands_1048944-16242081.jpg?w=2000",
  //       "feedback": "Excellent service! Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, ",
  //       "stars": 5
  //   },
  //   {
  //       "reviewer": "Isha Singhai",
  //       "profilePhotoURL": "https://img.freepik.com/free-photo/medium-shot-contemplative-man-seaside_23-2150531618.jpg?t=st=1726245849~exp=1726249449~hmac=d7c11b5cca8b9e178f28f4f617e86f9d08068f4fadbe8b1406bdd8c25d98104e&w=2000",
  //       "feedback": "Very good, but can improve punctuality. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo ",
  //       "stars": 4
  //   }
  //   ]
  // },
  // {
  //   "sID": "aniket",
  //   "reviews": [
  //     {
  //       "reviewer": "Aman Srivas",
  //       "profilePhotoURL": "https://img.freepik.com/free-photo/confident-handsome-guy-posing-against-white-wall_176420-32936.jpg?t=st=1726245954~exp=1726249554~hmac=bfebdb20085c2f1c81e1c1f707841302cae850c6ca29b66bed34d06d368b0fe6&w=2000",
  //       "feedback": "Not satisfied with the work. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis ",
  //       "stars": 2
  //     },
  //     {
  //       "reviewer": "Rekha Sharma",
  //       "profilePhotoURL": "https://img.freepik.com/free-photo/lifestyle-beauty-fashion-people-emotions-concept-young-asian-female-office-manager-ceo-with-pleased-expression-standing-white-background-smiling-with-arms-crossed-chest_1258-59329.jpg?t=st=1726245978~exp=1726249578~hmac=d5deec397a9bd4907b102df2d529680ffceff637b542e6b1e3fc74ed1aa64ca2&w=2000",
  //       "feedback": "Average experience.Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa ",
  //       "stars": 3
  //     }
  //   ]
  // }
  // ]''';

  handleMenuClick() {
    _scaffoldKey.currentState?.openDrawer();
  }

  handleBackClick() {
    Navigator.pop(context);
  }

  handleChatClick() {}

  Future<ServiceProvider> fetchData(String sID) async {
    final url1 = Uri.parse('$apiUrl/customers/getServiceProviderData');

    try {
      final response = await http.post(
        url1,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"sID": sID}),
      );

      print('Raw response body: ${response.body}'); // 🧠 Debug print here


      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print('Parsed JSON: $jsonData');
        return ServiceProvider.fromJson(jsonData);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final sID = args['sID'];

    if (sID == null) {
      //never gonna happen - the case where sID is not provided
      return const Center(child: Text('No Service Provider ID provided'));
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
              child: Text(
            AppStrings.appTitle,
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
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<ServiceProvider>(
          future: fetchData(sID),
          builder: (context, snapshot) {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            if (snapshot.connectionState == ConnectionState.waiting ) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColors.primary,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            }
            final serviceProvider = snapshot.data!;

            // else { niche else wala bracket
              // filter relevant information for selected provider
              // final providerBio = serviceProviderBioData.firstWhere(
              //   (bio) => bio.sID == sID,
              //   // orElse: () => null,
              // );
              // final providerInfo = basicInfoData.firstWhere(
              //   (info) => info.sID == sID,
              //   // orElse: () => null,
              // );
              // final providerImages = featuredImages.firstWhere(
              //   (images) => images.sID == sID,
              // );
              // final providerLanguages = languagesKnown.firstWhere(
              //   (languages) => languages.sID == sID,
              // );
              // final providerReviews = spReviews.firstWhere(
              //   (reviews) => reviews.sID == sID,
              // );
            print('Languages in Widget: ${serviceProvider!.languages}');

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      basicInfoBox(
                        serviceProvider.imgURL,
                        serviceProvider.sID,
                        serviceProvider.sName,
                        serviceProvider.category,
                        serviceProvider.newSProvider,
                        serviceProvider.rating,
                        serviceProvider.reviews,
                        serviceProvider.ordersCompleted,
                        serviceProvider.away,
                        // providerInfo.imgURL,
                        // providerInfo.sID,
                        // providerInfo.sName,
                        // providerInfo.category,
                        // providerInfo.newSProvider,
                        // providerInfo.rating,
                        // providerInfo.reviews,
                        // providerInfo.ordersCompleted,
                        // providerInfo.away,
                      ),
                      const SizedBox(height: 20.0), //remove later
                      serviceProviderBioBox(
                          serviceProvider.sID,
                          serviceProvider.info,
                          // providerBio.sID,
                          // providerBio.bio,
                          screenWidth, screenHeight),
                      const SizedBox(height: 20), //remove later
                      // featuredBox(
                      //   spData['sID'],
                      //   [], // put image URL list here if you have it from backend
                      // ),
                      // const SizedBox(height: 20),

                    languagesKnownBox(
                          serviceProvider.sID, serviceProvider.languages),
                      // const SizedBox(height: 20),
                      // reviewsBox(providerInfo.sID, providerReviews.reviews),
                    ],
                  ),
                ),
              );
            // } else wala bracket
          },
        ),
      ),
    );
  }
}

class ServiceProvider {
  final String sID;
  final String sName;
  final String imgURL;
  final String category;
  final bool newSProvider;
  final double rating;
  final int reviews;
  final int ordersCompleted;
  final double away;
  final String info;
  final List<String> languages;

  ServiceProvider({
    required this.sID,
    required this.sName,
    required this.imgURL,
    required this.category,
    required this.newSProvider,
    required this.rating,
    required this.reviews,
    required this.ordersCompleted,
    required this.away,
    required this.info,
    required this.languages,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    print('Languages from JSON: ${json['languages']}');
    return ServiceProvider(
      sID: json['sID'] ?? '',
      sName: json['sName'] ?? 'Unknown',
      imgURL: json['imgURL'] ?? '',
      category: json['category'] ?? '',
      newSProvider: json['newSProvider'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      ordersCompleted: json['ordersCompleted'] ?? 0,
      away: (json['away'] ?? 0).toDouble(),
      info: json['info'] ?? '',
      languages: List<String>.from(json['languages'] ?? ['Hindi']),
    );
  }
}

Widget basicInfoBox(
    String imgURL,
    String sID,
    String sName,
    String category,
    bool newSProvider,
    double rating,
    int reviews,
    int ordersCompleted,
    double away) {
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
                style: AppTextStyles.textExtraSmall
                    .merge(AppTextStyles.textMediumGrey),
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

Widget serviceProviderBioBox(
    String sID, String bio, double screenWidth, double screenHeight) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        constraints: BoxConstraints(
            maxHeight: screenHeight * 0.40, maxWidth: screenWidth * 0.95),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.bio,
                style:
                    AppTextStyles.textExtraBold.merge(AppTextStyles.textWhite),
              ),
              const SizedBox(height: 10),
              Text(
                bio,
                style: AppTextStyles.textSmall.merge(AppTextStyles.textWhite),
                softWrap: true,
              )
            ],
          ),
        ),
      )
    ],
  );
}

Widget featuredBox(String sID, List<String> imageURLs) {
  // return FutureBuilder<List<String>>(
  //     future: fetchImages(sID),
  // builder: (context, snapshot) {
  //   if (snapshot.connectionState == ConnectionState.waiting) {
  //     return const Center(child: CircularProgressIndicator());
  //   } else if (snapshot.hasError) {
  //     return Center(child: Text('Error: ${snapshot.error}'));
  //   } else if (!snapshot.hasData || snapshot.data == null) {
  //     return const Center(child: Text('No data available'));
  //   }
  //
  //   final imageURLs = snapshot.data!;

  return Row(
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.featured,
            style: AppTextStyles.textExtraBold.merge(AppTextStyles.textPrimary),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 108.0,
            width: 390.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageURLs.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 190.0,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(imageURLs[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    ],
  );
  // }
  // );
}

Widget languagesKnownBox(String sID, List<String> languages) {
  // return FutureBuilder<List<String>>(
  //     future: fetchLanguages(sID),
  // builder: (context, snapshot) {
  // if (languages.isEmpty) {
  //   return const SizedBox.shrink(); // nothing to show
  // }
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.languages,
            style: AppTextStyles.textExtraBold.merge(AppTextStyles.textPrimary),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 30.0,
            width: 390.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 64.0,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    // clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                        color: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    // child: Center(
                    child: Center(
                      child: Text(
                        languages[index],
                        style: AppTextStyles.textSmallBold
                            .merge(AppTextStyles.textWhite),
                      ),
                    ),
                    // ),
                  );
                }),
          ),
        ],
      ),
    ],
  );
}

Widget reviewsBox(String sID, List<Review> reviews) {
  // return FutureBuilder<List<Map<String, dynamic>>>(
  //     future: fetchReviews(sID),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Center(child: Text('Error: ${snapshot.error}'));
  //       } else if (!snapshot.hasData || snapshot.data == null) {
  //         return const Center(child: Text('No data available'));
  //       }
  //
  //       final reviews = snapshot.data!;

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppStrings.reviews,
        style: AppTextStyles.textExtraBold.merge(AppTextStyles.textPrimary),
      ),
      const SizedBox(height: 10),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: reviews.map((review) {
              return Container(
                width: 280,
                height: 114,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 24.0,
                          width: 24.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(review.profilePhotoURL),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            review.reviewer,
                            style: AppTextStyles.textSmallBold
                                .merge(AppTextStyles.textWhite),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16.0,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              review.stars.toString(),
                              style: AppTextStyles.textWhite,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(review.feedback,
                        style: AppTextStyles.textSmall
                            .merge(AppTextStyles.textWhite)),
                  ],
                ),
              );
            }).toList(),
          ))
    ],
  );
  // });
}

class BasicInfoBox {
  final String imgURL;
  final String sID;
  final String sName;
  final String category;
  final bool newSProvider;
  final double rating;
  final int reviews;
  final int ordersCompleted;
  final double away;
  BasicInfoBox({
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
  factory BasicInfoBox.fromJson(Map<String, dynamic> json) {
    return BasicInfoBox(
      imgURL: json['imgURL'],
      sID: json['sID'],
      sName: json['sName'],
      category: json['category'],
      newSProvider: json['newSProvider'],
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      ordersCompleted: json['ordersCompleted'],
      away: json['away'].toDouble(),
    );
  }
  @override
  String toString() {
    return 'BasicInfoBox(sID: $sID, sName: $sName, category: $category, rating: $rating)';
  }
}

class ServiceProviderBioBox {
  final String sID;
  final String bio;

  ServiceProviderBioBox({
    required this.sID,
    required this.bio,
  });
  factory ServiceProviderBioBox.fromJson(Map<String, dynamic> json) {
    return ServiceProviderBioBox(
      sID: json['sID'],
      bio: json['bio'],
    );
  }
  @override
  String toString() {
    return 'ServiceProviderBioBox(sID: $sID, bio: $bio)';
  }
}

class FeaturedBox {
  final String sID;
  final List<String> imageURLs;
  FeaturedBox({required this.sID, required this.imageURLs});
  factory FeaturedBox.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List<dynamic>;
    List<String> images = imageList.map((image) => image as String).toList();
    return FeaturedBox(sID: json['sID'], imageURLs: images);
  }
  @override
  String toString() {
    return 'FeaturedBox(sID: $sID, imageURLs: $imageURLs)';
  }
}

class LanguagesBox {
  final String sID;
  final List<String> languages;
  LanguagesBox({required this.sID, required this.languages});
  factory LanguagesBox.fromJson(Map<String, dynamic> json) {
    var languageList = json['languages'] as List<dynamic>;
    List<String> languages =
        languageList.map((language) => language as String).toList();
    return LanguagesBox(sID: json['sID'], languages: languages);
  }
  @override
  String toString() {
    return 'LanguagesBox(sID: $sID, languages: $languages)';
  }
}

class ServiceProviderReviewBox {
  final String sID;
  final List<Review> reviews;
  ServiceProviderReviewBox({required this.sID, required this.reviews});
  factory ServiceProviderReviewBox.fromJson(Map<String, dynamic> json) {
    var reviewList = json['reviews'] as List<dynamic>;
    List<Review> reviews =
        reviewList.map((review) => Review.fromJson(review)).toList();
    return ServiceProviderReviewBox(sID: json['sID'], reviews: reviews);
  }
  @override
  String toString() {
    return 'ServiceProviderReviewBox(sID: $sID, reviews: $reviews)';
  }
}

class Review {
  final String reviewer;
  final String profilePhotoURL;
  final String feedback;
  final int stars;

  Review(
      {required this.reviewer,
      required this.profilePhotoURL,
      required this.feedback,
      required this.stars});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        reviewer: json['reviewer'] ?? 'Anonymous',
        profilePhotoURL:
            json['profilePhotoURL'] ?? 'https://via.placeholder.com/24x24',
        feedback: json['feedback'] ?? ' ',
        stars: json['stars'] ?? 0);
  }

  @override
  String toString() {
    return 'Review(reviewer: $reviewer, profilePhotoURL: $profilePhotoURL, feedback: $feedback, stars: $stars)';
  }
}
