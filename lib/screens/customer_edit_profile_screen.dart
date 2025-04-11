import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workup/widgets/bottom_navigation_bar.dart';
import 'package:workup/utils/secure_storage.dart';

class CustomerEditProfileScreen extends StatefulWidget {
  const CustomerEditProfileScreen({super.key});

  @override
  State<CustomerEditProfileScreen> createState() => _CustomerEditProfileScreenState();
}

class _CustomerEditProfileScreenState extends State<CustomerEditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  final String? apiUrl = dotenv.env['API_BASE_URL'];

  var isLoading = false;

  late Map<String, dynamic> args;

  handleBackClick() {
    Navigator.pop(context);
  }
   
  handleChatClick() {}

  saveDetails () async {

    var email = await getEmail();
    String body = '{"email": "$email"';

    if (firstNameController.text != "") {
      body += ', "firstName": "${firstNameController.text}"';
    }
    if (middleNameController.text != "") {
      body += ', "middleName": "${middleNameController.text}"';
    }
    if (lastNameController.text != "") {
      body += ', "lastName": "${lastNameController.text}"';
    }
    if (religionController.text != "") {
      body += ', "religion": "${religionController.text}"';
    }
    if (phoneNumberController.text != "") {
      body += ', "phoneNumber": "${phoneNumberController.text}"';
    }
    if (addressLine1Controller.text != "") {
      body += ', "addressLine1": "${addressLine1Controller.text}"';
    }
    if (addressLine2Controller.text != "") {
      body += ', "addressLine2": "${addressLine2Controller.text}"';
    }
    if (cityController.text != "") {
      body += ', "city": "${cityController.text}"';
    }
    if (stateController.text != "") {
      body += ', "state": "${stateController.text}"';
    }
    if (zipCodeController.text != "") {
      body += ', "zipCode": ${zipCodeController.text}';
    }

    body += '}';

    try {
      final url1 = Uri.parse('$apiUrl/customers/updateCustomerDetails');

      final response = await http.put(
        url1,
        headers: {'Content-Type': 'application/json'}, // Optional headers
        body: body,
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        // setState(() {
        //   isLoading = false;
        // }); // Get JSON as a raw string
      } else {
          print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      if(args["firstName"] != null) firstNameController.text = args["firstName"];
      if(args["middleName"] != null) middleNameController.text = args["middleName"];
      if(args["lastName"] != null) lastNameController.text = args["lastName"];
      if(args["religion"] != null) religionController.text = args["religion"];
      if(args["phoneNumber"] != null) phoneNumberController.text = args["phoneNumber"];
      if(args["addressLine1"] != null) addressLine1Controller.text = args["addressLine1"];
      if(args["addressLine2"] != null) addressLine2Controller.text = args["addressLine2"];
      if(args["city"] != null) cityController.text = args["city"];
      if(args["state"] != null) stateController.text = args["state"];
      if(args["zipCode"] != null) zipCodeController.text = args["zipCode"].toString();

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
        drawer: const Drawer(),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(
                color: AppColors.primary,
              ));
            } else if(snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return SingleChildScrollView(

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(args["imgUrl"]),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Edit Picture'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildTextField('First Name', firstNameController),
                      buildTextField('Middle Name', middleNameController),
                      buildTextField('Last Name', lastNameController),
                      buildTextField('Religion', religionController),
                      buildTextField('Contact Number', phoneNumberController, keyboardType: TextInputType.phone),
                      buildTextField('Address Line 1', addressLine1Controller),
                      buildTextField('Address Line 2', addressLine2Controller),
                      buildTextField('City', cityController),
                      buildTextField('State', stateController),
                      buildTextField('PinCode', zipCodeController, keyboardType: TextInputType.number),
                      const SizedBox(height: 20),
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () async {
                              setState(() => isLoading = true); // Only this button will rebuild
                              await saveDetails();
                              setState(() => isLoading = false);
                            },
                            child: isLoading ?
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                              : const Text('Save'),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            }
          }),
        bottomNavigationBar: const CustomBottomNavigationBar()
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }
}

Widget buildTextField(String labelText, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
