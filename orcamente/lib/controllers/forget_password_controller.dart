import 'package:flutter/material.dart';
import 'package:orcamente/services/auth_service.dart';
import 'package:orcamente/core/validators.dart';

/// Controller for forgot password screen
/// Handles password recovery using AuthService and Result<T> pattern
class ForgotPasswordController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService;
  
  String errorMessage = '';
  String successMessage = '';
  bool isLoading = false;

  ForgotPasswordController({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Validates email using centralized validator
  bool validateEmail() {
    String email = emailController.text.trim();

    // Use centralized validator
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      errorMessage = emailError;
      successMessage = '';
      notifyListeners();
      return false;
    }

    errorMessage = '';
    notifyListeners();
    return true;
  }

  /// Sends password recovery email using AuthService with Result<T> pattern
  Future<void> recoverPassword() async {
    if (!validateEmail()) return;

    isLoading = true;
    notifyListeners();

    // Use AuthService with Result<T> pattern
    final result = await _authService.sendPasswordResetEmail(
      emailController.text.trim(),
    );

    // Handle result
    result.when(
      success: (_) {
        errorMessage = '';
        successMessage = 'Link de recuperação enviado para seu e-mail.';
        isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        errorMessage = error;
        successMessage = '';
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void clearMessages() {
    errorMessage = '';
    successMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
