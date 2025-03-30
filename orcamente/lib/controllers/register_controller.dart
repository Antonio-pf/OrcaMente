import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String errorMessage = '';

  bool validateRegistration() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      errorMessage = 'Todos os campos precisam ser preenchidos.';
      notifyListeners(); 
      return false;
    }

    if (!_isValidEmail(email)) {
      errorMessage = 'Email inválido.';
      notifyListeners(); 
      return false;
    }

    if (password != confirmPassword) {
      errorMessage = 'As senhas não coincidem.';
      notifyListeners(); 
      return false;
    }

    errorMessage = ''; 
    notifyListeners();
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }
}
