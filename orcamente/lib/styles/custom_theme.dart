// lib/theme/custom_theme.dart
import 'package:flutter/material.dart';

class CustomTheme {
  static const Color primaryColor = Color(0xFF17B8A6); 
  static const Color primaryLight = Color(0xFF4DD1C2); 
  static const Color primaryDark = Color(0xFF139E8D); 
  static const Color secondaryLight = Color(0xFFB3E6E2);
  static const Color secondaryDark = Color(0xFF0F7F72);
  static const Color neutralLight = Color(0xFFF0F0F0); 
  static const Color neutralDark = Color(0xFF2D2D2D); 

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: neutralLight,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: primaryLight, 
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: neutralDark), 
      bodyLarge: TextStyle(color: primaryDark), 
      headlineLarge: TextStyle(color: primaryColor, fontSize: 24),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryDark,
    scaffoldBackgroundColor: neutralDark, 
    colorScheme: ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: neutralLight), 
      bodyLarge: TextStyle(color: primaryLight), 
      headlineLarge: TextStyle(color: primaryDark, fontSize: 24),
    ),
  );
}
