import 'package:flutter/material.dart';

class ForgotPasswordController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  String errorMessage = '';

  bool validateEmail() {
    String email = emailController.text;

    if (email.isEmpty) {
      errorMessage = 'O e-mail é obrigatório.';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      errorMessage = 'E-mail inválido.';
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

  void recoverPassword() {
    if (validateEmail()) {
      print('Recuperação de senha para o email: ${emailController.text}');
    }
  }
}
