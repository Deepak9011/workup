import 'package:flutter/material.dart';
import 'package:workup/models/service_provider_model.dart';  // Import ServiceProvider model
import 'package:workup/utils/colors.dart';
import 'package:workup/utils/secure_storage.dart';
import 'package:workup/utils/strings.dart';
import 'package:workup/utils/text_styles.dart';
import '../services/auth_service.dart';


class ServiceProviderLoginScreen extends StatefulWidget {
  const ServiceProviderLoginScreen({super.key});

  @override
  State<ServiceProviderLoginScreen> createState() => _ServiceProviderLoginState();
}

class _ServiceProviderLoginState extends State<ServiceProviderLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // Register button click handler
  serviceProviderLoginButtonClick() {
    _loginServiceProvider();
  }

  registerServiceProvider(){
    Navigator.pushNamed(context, '/serviceProviderRegisterScreen');
  }


  Future<void> _loginServiceProvider() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final serviceProvider = ServiceProvider(email: email, password: password);
    final response = await _authService.loginServiceProvider(serviceProvider);
    print(response['code']);
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
        await saveType("sp");
        await saveToken(response['token']);
        await saveEmail(email);
        await savePassword(password);
        Navigator.pushReplacementNamed(
            context,
            '/serviceProviderHomepageScreen',
            arguments: {
              'email': email,
            }
        );
        break;
    // Add more cases as needed
      default:
      // Default statements if no cases match
    }
  }

  handleBackClick() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                            width: 128,
                            height: 128,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/WorkUpLogo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Login as Service Provider",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Please enter your registration email and password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2F2F2F),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(_emailController, 'Email or username'),
                          const SizedBox(height: 20),
                          _buildTextField(_passwordController, 'Password', obscureText: true),
                          const SizedBox(height: 20),
                          _buildElevatedButton('Login'),
                          const SizedBox(height: 20),
                          _buildSocialMediaOptions(),
                          const SizedBox(height: 20),
                          _buildRegisterRow(),
                          const SizedBox(height: 20),
                        ]),
                  ),
                ),
              ),
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
            borderSide: const BorderSide(color: Color(0xFFC1C1C1)),
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
          backgroundColor: const Color(0xFF86469C),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: serviceProviderLoginButtonClick,
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
              _buildSocialButton('Google', const FlutterLogo()),
              const SizedBox(width: 10),
              _buildSocialButton('Facebook', const FlutterLogo()),
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

  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(
            color: Color(0xFF2F2F2F),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: registerServiceProvider,
          child: const Text(
            'Register',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF86469C),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
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
