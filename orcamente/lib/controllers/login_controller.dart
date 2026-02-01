import 'package:flutter/material.dart';
import 'package:orcamente/services/auth_service.dart';
import 'package:orcamente/core/validators.dart';
import 'package:orcamente/views/home_page.dart';
import 'package:orcamente/views/quiz/quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for login screen
/// Handles login logic using AuthService and Result<T> pattern
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

  /// Validates and performs login
  Future<void> handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    errorMessage = '';
    isLoading = true;
    notifyListeners();

    // Validate email
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setError(emailError);
      isLoading = false;
      notifyListeners();
      return;
    }

    // Validate password is not empty
    if (password.isEmpty) {
      _setError('Senha é obrigatória.');
      isLoading = false;
      notifyListeners();
      return;
    }

    // Attempt login using AuthService with Result<T>
    final result = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Handle result
    result.when(
      success: (user) async {
        // Check if quiz was answered
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool quizAnswered = prefs.getBool('quizAnswered') ?? false;

        isLoading = false;
        notifyListeners();

        // Navigate based on quiz status
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
      },
      failure: (error, exception) {
        _setError(error);
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void _setError(String msg) {
    errorMessage = msg;
    notifyListeners();
  }

  void clearErrorMessage() {
    errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
