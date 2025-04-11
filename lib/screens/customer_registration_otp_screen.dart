import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';

import '../services/auth_service.dart';
class CustomerRegistrationOtpScreen extends StatefulWidget {
  const CustomerRegistrationOtpScreen({super.key});

  @override
  State<CustomerRegistrationOtpScreen> createState() => _CustomerRegistrationOtpScreenState();
}

class _CustomerRegistrationOtpScreenState extends State<CustomerRegistrationOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final AuthService _authService = AuthService();

  bool isOTPVerified = false;

  String? email;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1) {
          if (i < _controllers.length - 1) {
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void verifyButtonClick(){
    _verify();
  }

  Future<void> _verify() async {

    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args.containsKey("email")) {
      email = args["email"];
    }

    String otp = "";
    for(var i in _controllers){
      otp += i.text;
    }

    final response = await _authService.verifyOTP(email!, otp);

    switch (response) {
      case 400:
      // Statements for value1
        break;
      case 401:
      // Statements for value2
        break;
      case 402:
      // Statements for value2
        break;
      case 200:
        setState(() {
          isOTPVerified = true; // Update the state to reflect the OTP verification
        });
        Future.delayed(const Duration(seconds: 3), redirectToLogin);
        break;
    // Add more cases as needed
      default:
      // Default statements if no cases match
    }
  }

  void redirectToLogin(){
    Navigator.pushReplacementNamed(context, '/loginScreen');
  }

  void handleBackClick(){
    Navigator.pop(context);
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
          actions: const [
            SizedBox(width: 48.0, height: 48.0,),
          ],
        ),
      
        body: Center(
          child:
            !isOTPVerified?
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 128, // Reduced width
                    height: 128, // Reduced height
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/WorkUpLogo.png'),
                        fit: BoxFit.contain, // Ensure the entire image is visible
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 340,
                    child: Text(
                      'Enter OTP sent to Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    width: 340,
                    child: Text(
                      'An OTP has been sent to your registration email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2F2F2F),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 340,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 1, color: Color(0xFFC1C1C1)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < _controllers.length - 1) {
                                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildElevatedButton("Verify"),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Didn’t receive OTP?',
                        style: TextStyle(
                          color: Color(0xFF2F2F2F),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          // Add your resend action here
                        },
                        child: const Text(
                          'Resend',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF86469C),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ):
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'OTP Verified!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(String text) {
    return SizedBox(
      width: 340,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF86469C),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: verifyButtonClick,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
