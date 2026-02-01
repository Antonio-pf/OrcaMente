import 'package:flutter/material.dart';
import 'package:orcamente/services/auth_service.dart';
import 'package:orcamente/core/validators.dart';

/// Controller for registration screen
/// Handles user registration using AuthService and Result<T> pattern
class RegisterController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthService _authService;

  String errorMessage = '';
  bool isLoading = false;

  RegisterController({AuthService? authService})
    : _authService = authService ?? AuthService();

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  /// Clears the error message
  void clearErrorMessage() {
    if (errorMessage.isNotEmpty) {
      errorMessage = '';
      notifyListeners();
    }
  }

  /// Validates all registration fields using centralized validators
  bool validateRegistration() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Validate name
    final nameError = Validators.validateName(name);
    if (nameError != null) {
      _setError(nameError);
      return false;
    }

    // Validate email
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setError(emailError);
      return false;
    }

    // Validate phone
    final phoneError = Validators.validatePhone(phone);
    if (phoneError != null) {
      _setError(phoneError);
      return false;
    }

    // Validate password
    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      _setError(passwordError);
      return false;
    }

    // Validate password confirmation
    final confirmError = Validators.validatePasswordConfirmation(
      password,
      confirmPassword,
    );
    if (confirmError != null) {
      _setError(confirmError);
      return false;
    }

    _setError('');
    return true;
  }

  /// Registers new user using AuthService with Result<T> pattern
  Future<bool> registerUser() async {
    if (!validateRegistration()) {
      return false;
    }

    _setLoading(true);
    _setError('');

    // Use AuthService with Result<T> pattern
    final result = await _authService.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );

    // Handle result
    return result.when(
      success: (user) {
        _setLoading(false);
        return true;
      },
      failure: (error, exception) {
        _setError(error);
        _setLoading(false);
        return false;
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
