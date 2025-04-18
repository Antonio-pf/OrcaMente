import 'package:flutter/material.dart';
import 'package:orcamente/views/home_page.dart';
import 'package:orcamente/views/quiz/quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  String errorMessage = '';

  LoginController({
    required this.emailController,
    required this.passwordController,
  });

  bool validateLogin() {
    String email = emailController.text;
    String password = passwordController.text;
    errorMessage = '';

    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Por favor, preencha todos os campos.';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      errorMessage = 'Email inválido.';
      notifyListeners();
      return false;
    }

    if (email == "teste@orcamente.com" && password == "1234") {
      print('Usuário validado com sucesso!');
      return true;
    } else {
      errorMessage = 'Email ou senha incorretos.';
      notifyListeners();
      return false;
    }
  }

  Future<void> handleLogin(BuildContext context) async {
    if (!validateLogin()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool quizAnswered = prefs.getBool('quizAnswered') ?? true;

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
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  void clearErrorMessage() {
    errorMessage = '';
    notifyListeners();
  }
}
