import 'package:flutter/material.dart';

class CustomTheme {
  
  static const Color primaryColor = Color(0xFF10B981); 
  static const Color primaryDark = Color(0xFF047857); 
  static const Color primaryLight = Color(0xFFA7F3D0); 
  static const Color primaryVeryLight = Color(0xFFECFDF5); 

  static const Color secondaryColor = Color(0xFF0EA5E9); 
  static const Color secondaryDark = Color(0xFF0369A1); 

  static const Color neutralBlack = Color(0xFF1F2937); 
  static const Color neutralDarkGray = Color(0xFF4B5563); 
  static const Color neutralGray = Color(0xFF9CA3AF); 
  static const Color neutralLightGray = Color(0xFFE5E7EB); 
  static const Color neutralWhite = Color(0xFFFFFFFF); 

  static const Color successColor = Color(0xFF10B981); 
  static const Color errorColor = Color(0xFFEF4444); 
  static const Color warningColor = Color(0xFFF59E0B); 
  static const Color infoColor = Color(0xFF3B82F6);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: neutralWhite, 
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: neutralBlack, fontWeight: FontWeight.bold), 
      bodyMedium: TextStyle(color: neutralBlack), 
      bodyLarge: TextStyle(color: neutralDarkGray), 
      titleLarge: TextStyle(color: neutralGray),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: neutralLightGray,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryDark,
    scaffoldBackgroundColor: neutralBlack,
    colorScheme: ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: neutralWhite, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: neutralWhite), 
      bodyLarge: TextStyle(color: neutralLightGray), 
      titleLarge: TextStyle(color: neutralGray), 
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: neutralDarkGray,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryLight),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
