import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orcamente/services/auth_service.dart';

class ForgotPasswordController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService;
  
  String errorMessage = '';
  String successMessage = '';
  bool isLoading = false;

  ForgotPasswordController({AuthService? authService})
      : _authService = authService ?? AuthService();

  bool validateEmail() {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      errorMessage = 'O e-mail é obrigatório.';
      successMessage = '';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      errorMessage = 'E-mail inválido.';
      successMessage = '';
      notifyListeners();
      return false;
    }

    errorMessage = '';
    notifyListeners();
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  Future<void> recoverPassword() async {
    if (!validateEmail()) return;

    isLoading = true;
    notifyListeners();

    try {
      // Usar AuthService ao invés de FirebaseAuth direto
      await _authService.sendPasswordResetEmail(emailController.text.trim());

      errorMessage = '';
      successMessage = 'Link de recuperação enviado para seu e-mail.';
    } catch (e) {
      errorMessage = e.toString();
      successMessage = '';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = '';
    successMessage = '';
    notifyListeners();
  }
}
