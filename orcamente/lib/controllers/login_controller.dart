import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orcamente/views/home_page.dart';
import 'package:orcamente/views/quiz/quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  String errorMessage = '';

  // Defina como false em produção para não mostrar mensagens detalhadas
  static const bool isDebug = false;

  LoginController({
    required this.emailController,
    required this.passwordController,
  });

  Future<void> handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    errorMessage = '';
    notifyListeners();

    if (email.isEmpty || password.isEmpty) {
      _setError('Por favor, preencha todos os campos.');
      return;
    }

    if (!_isValidEmail(email)) {
      _setError('Formato de e-mail inválido.');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

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
    } on FirebaseAuthException catch (e) {
      _setError(_firebaseErrorMessage(e));
    } catch (_) {
      _setError('Erro inesperado. Verifique sua conexão.');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  String _firebaseErrorMessage(FirebaseAuthException error) {
    if (isDebug) {
      return '[${error.code}] ${error.message ?? 'Erro desconhecido.'}';
    }

    switch (error.code) {
      case 'user-not-found':
      case 'wrong-password':
        return 'E-mail ou senha incorretos.';
      case 'invalid-email':
        return 'Formato de e-mail inválido.';
      case 'user-disabled':
        return 'A conta foi desativada.';
      default:
        return 'Ocorreu um erro ao fazer login. Tente novamente.';
    }
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
