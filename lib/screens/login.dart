import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 220, // Reduced width
                height: 220, // Reduced height
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/workup logo.jpg'),
                    fit: BoxFit.contain, // Ensure the entire image is visible
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome to Work Up",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(
                width: 340,
                child: Text(
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
              ),
              const SizedBox(height: 8),
              _buildTextField(_emailController, 'Email or username'),
              const SizedBox(height: 8),
              _buildTextField(_passwordController, 'Password',
                  obscureText: true),
              const SizedBox(height: 20),
              _buildElevatedButton('Continue'),
              const SizedBox(height: 20), // Adjusted height for spacing
              _buildSocialMediaOptions(),
              const SizedBox(height: 15),
              _buildText('Are you a Service Provider?'),
              const SizedBox(height: 10),
              Container(
                width: 340,
                height: 36,
                padding: const EdgeInsets.all(10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFF86469C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Login as Service Provider',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF86469C),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'to become a Service Provider',
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
              const SizedBox(height: 20), // Add spacing before forgot password
              _buildRegisterRow(),
              const SizedBox(height: 20), // Add spacing before forgot password
              _buildForgotPasswordAtBottom(), // Move to the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
        onPressed: () {
          // Handle login logic here
        },
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
            child: const Text(
              'Forgot Password?',
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton('Google',
                  const FlutterLogo()), // Replace with Google logo if needed
              const SizedBox(width: 10),
              _buildSocialButton('Facebook',
                  const FlutterLogo()), // Replace with Facebook logo if needed
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
        style: const TextStyle(
          color: Color(0xFF2F2F2F),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 0,
        ),
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
        const Text(
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
