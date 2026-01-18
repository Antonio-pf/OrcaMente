import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orcamente/services/auth_service.dart';

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

  bool validateRegistration() {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _setError('Todos os campos precisam ser preenchidos.');
      return false;
    }

    if (!_isValidEmail(email)) {
      _setError('Email inválido.');
      return false;
    }

    if (!_isValidPassword(password)) {
      _setError(
        'Senha deve ter no mínimo 8 caracteres, incluindo letras maiúsculas, minúsculas e caracteres especiais.',
      );
      return false;
    }

    if (password != confirmPassword) {
      _setError('As senhas não coincidem.');
      return false;
    }

    _setError('');
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
  }

  
  Future<bool> registerUser() async {
    if (!validateRegistration()) {
      return false;
    }

    _setLoading(true);
    _setError('');

    try {
      // Usar AuthService ao invés de chamadas diretas ao Firebase
      final user = await _authService.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (user == null) {
        _setError('Falha ao criar conta. Tente novamente.');
        return false;
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

}
