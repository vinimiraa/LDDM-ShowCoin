import 'package:flutter/material.dart';
import 'package:src/screens/login_screen.dart';
import 'package:src/screens/utils.dart';
import 'main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Show Coin',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter',
      ),
      home: LoginScreen(), // Define a tela inicial
    );
  }
}
