import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/about_page.dart';
import 'package:orcamente/views/forget_password.dart';
import 'package:orcamente/views/login_page.dart';
import 'package:orcamente/views/register_page.dart'; 

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(), 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrçaMente',
      theme: CustomTheme.lightTheme,  
      darkTheme: CustomTheme.darkTheme,  
      themeMode: ThemeMode.system,
      home: LoginPage(),
      builder: DevicePreview.appBuilder,
      routes: {
        '/register': (context) => CadastroPage(),
        '/forget-password': (context) => ForgotPasswordPage(), 
        '/about': (context) => AboutPage(),
      },
    );
  }
}
