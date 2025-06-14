import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  String errorMessage = '';
  String successMessage = '';
  bool isLoading = false;

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
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      errorMessage = '';
      successMessage = 'Link de recuperação enviado para seu e-mail.';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Usuário não encontrado com esse e-mail.';
          break;
        case 'invalid-email':
          errorMessage = 'E-mail inválido.';
          break;
        default:
          errorMessage = 'Erro: ${e.message}';
      }
      successMessage = '';
    } catch (e) {
      errorMessage = 'Erro inesperado.';
      successMessage = '';
    }

    isLoading = false;
    notifyListeners();
  }

  void clearMessages() {
    errorMessage = '';
    successMessage = '';
    notifyListeners();
  }
}
