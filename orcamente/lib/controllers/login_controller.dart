import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orcamente/services/auth_service.dart';
import 'package:orcamente/views/home_page.dart';
import 'package:orcamente/views/quiz/quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AuthService _authService;
  
  String errorMessage = '';
  bool isLoading = false;

  LoginController({
    required this.emailController,
    required this.passwordController,
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  Future<void> handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    errorMessage = '';
    isLoading = true;
    notifyListeners();

    if (email.isEmpty || password.isEmpty) {
      _setError('Por favor, preencha todos os campos.');
      isLoading = false;
      notifyListeners();
      return;
    }

    if (!_isValidEmail(email)) {
      _setError('Formato de e-mail inválido.');
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // Usar AuthService ao invés de FirebaseAuth direto
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user == null) {
        _setError('Falha ao fazer login. Tente novamente.');
        isLoading = false;
        notifyListeners();
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool quizAnswered = prefs.getBool('quizAnswered') ?? true;

      isLoading = false;
      notifyListeners();

      if (!quizAnswered) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuizPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      _setError(e.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  void _setError(String msg) {
    errorMessage = msg;
    notifyListeners();
  }

  void clearErrorMessage() {
    errorMessage = '';
    notifyListeners();
  }
}
