import 'package:client/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10.0),
  );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColor.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20.0),
      enabledBorder: _border(AppColor.borderColor),
      focusedBorder: _border(AppColor.gradient2),
      errorBorder:  _border(AppColor.gradient2),
    ),
  );
}