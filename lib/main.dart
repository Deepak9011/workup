import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workup/screens/bid/customer/BidAcceptanceScreenCustomer.dart';
import 'package:workup/screens/bid/customer/CustomerBidScreen.dart';
import 'package:workup/screens/bid/serviceProvider/BidListScreenServiceProvider.dart';
import 'package:workup/screens/bid/serviceProvider/ServiceProviderBidDetailScreen.dart';
import 'package:workup/screens/customer_edit_profile_screen.dart';
import 'package:workup/screens/homepage_screen.dart';
import 'package:workup/screens/order_history_screen.dart';
import 'package:workup/screens/serviceProvider/ServiceProviderDashboard.dart';
import 'package:workup/screens/serviceProvider/ServiceProviderProfile.dart';
import 'package:workup/screens/serviceprovider_account_profile_screen.dart';
import 'package:workup/screens/serviceprovider_homepage_screen.dart';
import 'package:workup/screens/serviceprovider_order_confirm_screen.dart';
import 'package:workup/screens/serviceprovider_profile_screen.dart';
import 'package:workup/screens/serviceproviderlist_screen.dart';
import 'package:workup/screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workup/screens/serviceprovider_otp_screen.dart';
import 'package:workup/screens/serviceprovider_register_screen.dart';
import 'package:workup/screens/serviceprovider_login_screen.dart';
import 'package:workup/screens/customer_registration_screen.dart';
import 'package:workup/screens/customer_registration_otp_screen.dart';
import 'package:workup/screens/serviceprovider_fullprofile_screen.dart';
import 'package:workup/screens/customer_profile_screen.dart';
import 'package:workup/screens/customer_cart_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions here
  await requestAllPermissions();
  runApp(const MyApp());
}

Future<void> requestAllPermissions() async {
  // Create a list of permissions to request
  List<Permission> permissions = [
    Permission.camera,
    Permission.microphone,
    Permission.location,
    Permission.storage,
    Permission.contacts,
    Permission.phone,
    Permission.sms,
    // Add any other permissions you need
  ];

  // Request all permissions
  Map<Permission, PermissionStatus> statuses = await permissions.request();

  // Handle the permissions' statuses if needed
  statuses.forEach((permission, status) {
    if (status.isGranted) {
      // print('${permission.toString()} granted');
    } else if (status.isDenied) {
      // print('${permission.toString()} denied');
    } else if (status.isPermanentlyDenied) {
      // The user permanently denied the permission, open app settings
      openAppSettings();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Transparent status bar
      systemNavigationBarColor:
          Colors.transparent, // Transparent navigation bar
      statusBarIconBrightness:
          Brightness.dark, // Icons' brightness in the status bar
      systemNavigationBarIconBrightness:
          Brightness.dark, // Icons' brightness in the nav bar
    ));

    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: '/loginScreen',
      routes: {
        // '/': (context) => const LoginScreen(),
        '/loginScreen': (context) => const LoginScreen(),
        '/homepageScreen': (context) => const HomepageScreen(),
        '/serviceProviderListScreen': (context) =>
            const ServiceProviderListScreen(),
        '/customerRegistrationScreen': (context) =>
            const CustomerRegisterScreen(),
        '/customerOtpScreen': (context) =>
            const CustomerRegistrationOtpScreen(),
        '/customerProfileScreen': (context) => const CustomerProfileScreen(),
        '/customerEditProfileScreen': (context) =>
            const CustomerEditProfileScreen(),
        '/customerCartScreen': (context) => const CustomerCartScreen(),
        '/customerBidScreen': (context) =>
            const CustomerBidScreen(customerId: 'cust123deepak'),
        '/orderHistoryScreen': (context) => const OrderHistoryScreen(),
        '/bidAcceptanceScreenCustomer': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return BidAcceptanceScreenCustomer(bidId: args['bidId']);
        },

        // Service Provider Routes
        '/serviceProviderRegisterScreen': (context) =>
            const ServiceProviderRegisterScreen(),
        '/serviceProviderOtpScreen': (context) =>
            const ServiceProviderOtpScreen(),
        '/serviceProviderLoginScreen': (context) =>
            const ServiceProviderLoginScreen(),
        '/serviceProviderFullProfileScreen': (context) =>
            const ServiceProviderFullProfileScreen(),
        '/serviceProviderProfileScreen': (context) =>
            const ServiceProviderProfileScreen(),
        '/serviceProviderHomepageScreen': (context) =>
            const ServiceProviderHomepageScreen(),
        '/serviceProviderAccountProfileScreen': (context) =>
            const ServiceProviderProfile(userData: {
              "_id": "67fd4c704a52a46c53b2f99b",
              "firstName": "Aarav",
              "middleName": "Kumar",
              "lastName": "Sharma",
              "email": "aarav.sharma@example.com",
              "phoneNumber": "+919876543210",
              "dateOfBirth": "1998-07-15",
              "imgURL": "https://example.com/images/aarav-sharma.jpg",
              "imgPublicId": "service_provider/aarav-sharma",
              "rating": 4.7,
              "reviewCount": 35,
              "newSProvider": false,
              "startingPrice": 150,
              "subcategories": ["Electrical", "Appliance Repair"],
              "languages": ["Hindi", "English"],
              "joiningDate": "2023-05-12T10:25:45.000Z",
              "verificationStatus": "verified",
              "activityStatus": "active",
              "uuid": "b7e123c2-7a3a-4d9c-8810-2fcd19e548b4",
              "reviews": [
                {
                  "userId": "98ad431a-02b6-4f56-8ea3-7c3a4c4e9e2e",
                  "rating": 5,
                  "comment": "Excellent service and very polite!",
                  "date": "2024-01-15T14:20:00.000Z"
                },
                {
                  "userId": "8fc8b65e-b5f2-42ab-a8fb-cc9f90a5e70d",
                  "rating": 4,
                  "comment": "Arrived on time and solved the issue quickly.",
                  "date": "2024-03-05T11:00:00.000Z"
                }
              ],
              "__v": 1,
              "info": "Experienced electrician and appliance repair expert.",
              "category": "5a9c7dcd-99fc-4e3e-bac8-73c18a5e2c65"
            }),
        '/serviceProviderOrderConfirmScreen': (context) =>
            const ServiceProviderOrderConfirmScreen(),
        '/serviceProviderDashboard': (context) => ServiceProviderDashboard(),

        // Bidding Routes
        '/bidListScreenServiceProvider': (context) =>
            const BidListScreenServiceProvider(),
        '/serviceProviderBidDetailScreen': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ServiceProviderBidDetailScreen(
            bidData: args,
          );
        },
        // '/serviceProviderBidDetailScreen': (context) =>
        //     ServiceProviderBidDetailScreen(
        //       bidData: {
        //         '_id': 'bid001',
        //         'customerId': 'cust123',
        //         'category': 'Plumbing',
        //         'description': 'Fix kitchen sink leakage',
        //         'serviceTime': DateTime.now().toIso8601String(),
        //         'startBidTime': DateTime.now()
        //             .subtract(const Duration(hours: 2))
        //             .toIso8601String(),
        //         'endBidTime': DateTime.now()
        //             .add(const Duration(hours: 2))
        //             .toIso8601String(),
        //         'maxAmount': 500,
        //         'address': '221B Baker Street',
        //         'state': 'London',
        //         'country': 'UK',
        //         'additionalNotes': 'Please bring proper tools.',
        //         'image': {
        //           'image1': 'sink1.jpg',
        //           'image2': 'sink2.jpg',
        //           'image3': null,
        //           'image4': null,
        //           'image5': null,
        //         }
        //       },
        //     ),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        useMaterial3: true,
      ),
      home: const BidListScreenServiceProvider(),
    );
  }
}
