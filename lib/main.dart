import 'package:flutter/material.dart';
import 'package:workup/screens/login.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(), // Mark Login as const if possible
      },
    ),
  );
}
