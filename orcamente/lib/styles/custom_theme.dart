import 'package:flutter/material.dart';

class CustomTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF10B981); // Verde principal
  static const Color primaryDark = Color(0xFF047857); // Verde escuro
  static const Color primaryLight = Color(0xFFA7F3D0); // Verde claro
  static const Color primaryVeryLight = Color(0xFFECFDF5); // Verde muito claro

  // Cores secundárias (Azul)
  static const Color secondaryColor = Color(0xFF0EA5E9); // Azul
  static const Color secondaryDark = Color(0xFF0369A1); // Azul escuro

  // Cores neutras
  static const Color neutralBlack = Color(0xFF1F2937); // Preto
  static const Color neutralDarkGray = Color(0xFF4B5563); // Cinza escuro
  static const Color neutralGray = Color(0xFF9CA3AF); // Cinza médio
  static const Color neutralLightGray = Color(0xFFE5E7EB); // Cinza claro
  static const Color neutralWhite = Color(0xFFFFFFFF); // Branco

  // Cores de estados
  static const Color successColor = Color(0xFF10B981); // Sucesso
  static const Color errorColor = Color(0xFFEF4444); // Erro
  static const Color warningColor = Color(0xFFF59E0B); // Alerta
  static const Color infoColor = Color(0xFF3B82F6); // Informação

  // Tema Claro
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
      headlineLarge: TextStyle(color: neutralBlack, fontWeight: FontWeight.bold), // Para títulos
      bodyMedium: TextStyle(color: neutralBlack), // Para textos principais
      bodyLarge: TextStyle(color: neutralDarkGray), // Para textos secundários
      titleLarge: TextStyle(color: neutralGray), // Para subtítulos
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

  // Tema Escuro
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
      headlineLarge: TextStyle(color: neutralWhite, fontWeight: FontWeight.bold), // Para títulos
      bodyMedium: TextStyle(color: neutralWhite), // Para textos principais
      bodyLarge: TextStyle(color: neutralLightGray), // Para textos secundários
      titleLarge: TextStyle(color: neutralGray), // Para subtítulos
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
