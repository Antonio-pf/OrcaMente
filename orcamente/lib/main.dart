import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      builder: DevicePreview.appBuilder,
      routes: {
        '/register': (context) => CadastroPage(),
        '/forget-password': (context) => ForgetPasswordPage(), 
      },
    );
  }
}
