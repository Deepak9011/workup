import 'package:flutter/material.dart';
import 'package:workup/models/customer_model.dart';
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/secure_storage.dart';
import 'package:workup/utils/text_styles.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  continueButtonClick(){
    // Navigator.pushReplacementNamed(context, '/homepageScreen');
    _login();
  }
  registerCustomer(){
    Navigator.pushNamed(context, '/customerRegistrationScreen');
  }

  registerServiceProvider(){
    Navigator.pushNamed(context, '/serviceProviderRegisterScreen');
  }

  loginServiceProviderClick(){
    Navigator.pushNamed(context, '/serviceProviderLoginScreen');
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final customer = Customer(email: email, password: password);
    final response = await _authService.login(customer);

    switch (response['code']) {
      case 'Error':
      // Statements for value1
        break;
      case 'InvalidEmail':
      // Statements for value2
        break;
      case 'InvalidPassword':
      // Statements for value2
        break;
      case 'Success':
        await saveType("cu");
        await saveToken(response['token']);
        await saveEmail(email);
        await savePassword(password);
        Navigator.pushReplacementNamed(context, '/homepageScreen');
        break;
    // Add more cases as needed
      default:
      // Default statements if no cases match
    }
  }

  Future<void> _checkLogin() async {
    var type = await getType();
    var token = await getToken();
    var email = await getEmail();

    switch(type){
      case 'cu':
        var loginState = await _authService.verifyLogin(email!, token!);
        if (loginState!) {
          Navigator.pushReplacementNamed(context, '/homepageScreen');
        }
        break;
      case 'sp':
        var loginState = await _authService.verifyLoginServiceProvider(email!, token!);
        if (loginState!) {
          Navigator.pushReplacementNamed(context, '/serviceProviderHomepageScreen');
        }
        break;
    }

  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          const SizedBox(height: 10),
                          Text(
                            "Welcome to Work Up",
                            style: AppTextStyles.heading2.merge(AppTextStyles.textBlack)
                            // TextStyle(
                            //   color: Colors.black,
                            //   fontSize: 20,
                            //   fontFamily: 'Inter',
                            //   fontWeight: FontWeight.bold,
                            // ),
                          ),
                          const SizedBox(height: 10),
                           Text(
                            'Please enter your registration email and password',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.text1.merge(AppTextStyles.textDarkGrey)
                            // TextStyle(
                            //   color: Color(0xFF2F2F2F),
                            //   fontSize: 12,
                            //   fontFamily: 'Inter',
                            //   fontWeight: FontWeight.w400,
                            //   height: 1.5,
                            // ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(_emailController, 'Email or username'),
                          const SizedBox(height: 20),
                          _buildTextField(_passwordController, 'Password', obscureText: true),
                          const SizedBox(height: 20),
                          _buildElevatedButton('Continue'),
                          const SizedBox(height: 20), // Adjusted height for spacing
                          // _buildSocialMediaOptions(),
                          const SizedBox(height: 20),
                          _buildRegisterRow(),
                          const SizedBox(height: 20),
                          _buildText('Are you a Service Provider?'),
                          const SizedBox(height: 20),
                          _buildLoginSPButton(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: registerServiceProvider,
                                child: Text(
                                  'Register',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.text2.merge(AppTextStyles.textPrimary)
                                  // TextStyle(
                                  //   color: Color(0xFF86469C),
                                  //   fontSize: 12,
                                  //   fontFamily: 'Inter',
                                  //   fontWeight: FontWeight.w500,
                                  //   height: 0,
                                  // ),
                                ),
                              ),
                              const SizedBox(width: 4),
                               Text(
                                'to become a Service Provider',
                                style: AppTextStyles.text2.merge(AppTextStyles.textDarkGrey)
                                // TextStyle(
                                //   color: Color(0xFF2F2F2F),
                                //   fontSize: 12,
                                //   fontFamily: 'Inter',
                                //   fontWeight: FontWeight.w500,
                                //   height: 0,
                                // ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20), // Add spacing before forgot password
                        ]
                    ),
                  ),
                ),
              ),
              // Add spacing before forgot password
              _buildForgotPasswordAtBottom(), // Move to the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return SizedBox(
      width: 340,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(String text) {
    return SizedBox(
      width: 340,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          // const Color(0xFF86469C),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: continueButtonClick,
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

  Widget _buildLoginSPButton() {
    return SizedBox(
      width: 340,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          // const Color(0xFF86469C),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: loginServiceProviderClick,
        child: const Text(
          'Login as Service Provider',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordAtBottom() {
    return SizedBox(
      width: 340,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              // Handle forgot password logic here
            },
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.text2.merge(AppTextStyles.textPrimary)
              // TextStyle(
              //   color: Color(0xFF86469C),
              //   fontSize: 12,
              //   fontFamily: 'Inter',
              //   fontWeight: FontWeight.w500,
              //   height: 0,
              // ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaOptions() {
    return SizedBox(
      width: 340,
      child: Column(
        children: [
          const Text(
            'Or via social network',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2F2F2F),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton('Google', const FlutterLogo()), // Replace with Google logo if needed
              const SizedBox(width: 10),
              _buildSocialButton('Facebook', const FlutterLogo()), // Replace with Facebook logo if needed
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String text, Widget icon) {
    return Container(
      width: 165,
      height: 36,
      padding: const EdgeInsets.all(6),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFC1C1C1)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 24, height: 24, child: icon),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF2F2F2F),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return SizedBox(
      width: 340,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.text2.merge(AppTextStyles.textDarkGrey)
        // TextStyle(
        //   color: Color(0xFF2F2F2F),
        //   fontSize: 12,
        //   fontFamily: 'Inter',
        //   fontWeight: FontWeight.w500,
        //   height: 0,
        // ),
      ),
    );
  }

  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: AppTextStyles.text1.merge(AppTextStyles.textDarkGrey)
          // TextStyle(
          //   color: Color(0xFF2F2F2F),
          //   fontSize: 12,
          //   fontFamily: 'Inter',
          //   fontWeight: FontWeight.w400,
          //   height: 0,
          // ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: registerCustomer,
          child: Text(
            'Register',
            textAlign: TextAlign.center,
            style: AppTextStyles.text2.merge(AppTextStyles.textPrimary)
            // TextStyle(
            //   color: Color(0xFF86469C),
            //   fontSize: 12,
            //   fontFamily: 'Inter',
            //   fontWeight: FontWeight.w500,
            //   height: 0,
            // ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}