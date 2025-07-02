import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/pages/signin_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: const SigninPage(),
    );
  }
}