import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';

import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/controllers/theme_controller.dart';

import 'package:orcamente/views/about_page.dart';
import 'package:orcamente/views/forget_password.dart';
import 'package:orcamente/views/home_page.dart';
import 'package:orcamente/views/login_page.dart';
import 'package:orcamente/views/register_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: DevicePreview(
        enabled: true, // pode desligar em produção
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      title: 'OrçaMente',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: themeController.themeMode,
      home: LoginPage(),
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      routes: {
        '/register': (context) => const CadastroPage(),
        '/forget-password': (context) => ForgotPasswordPage(),
        '/about': (context) => const AboutPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
