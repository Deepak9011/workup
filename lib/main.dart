import 'package:flutter/material.dart';
import 'package:workup/screens/splash_screen.dart';

void main() {
  runApp(const MyApp()
      // MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   initialRoute: '/',
      //   routes: {
      //     '/': (context) => const Login(), // Mark Login as const if possible
      //   },
      // ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
