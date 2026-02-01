import 'package:flutter/material.dart';

class CustomTheme {
  // Cores primárias
  static const Color primaryColor = Color(0xFF10B981); // Verde médio
  static const Color primaryDark = Color(0xFF065F46); // Verde escuro (ajustado)
  static const Color primaryLight = Color(0xFF6EE7B7); // Verde claro
  static const Color primaryVeryLight = Color(
    0xFFECFDF5,
  ); // Verde bem suave (cards no light)

  // Cores secundárias
  static const Color secondaryColor = Color(0xFF0EA5E9); // Azul vibrante
  static const Color secondaryDark = Color(0xFF0369A1); // Azul escuro

  // Tons neutros
  static const Color neutralBlack = Color(0xFF111827); // Fundo dark
  static const Color neutralDarkGray = Color(0xFF1F2937); // Cards no dark
  static const Color neutralGray = Color(0xFF6B7280); // Textos médios
  static const Color neutralLightGray = Color(
    0xFFE5E7EB,
  ); // Campos input no light
  static const Color neutralWhite = Color(0xFFFFFFFF);

  // Estados e alertas
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // Cores para conquistas bloqueadas
  static const Color lockedAchievementBackground = Color(0xFF2D2F33); // Dark
  static const Color lockedAchievementText = Color(0xFF7B7F85);

  static Color cardColor(BuildContext context) {
    return Theme.of(context).cardColor;
  }

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: neutralWhite,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: neutralBlack,
        fontWeight: FontWeight.bold,
      ),
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
    cardColor: primaryVeryLight,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryDark,
    scaffoldBackgroundColor: neutralBlack,
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: neutralWhite,
        fontWeight: FontWeight.bold,
      ),
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
    cardColor: neutralDarkGray, // Mais neutro que primaryDark
  );
}
