import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String errorMessage = '';

  // Método para validar o cadastro
  bool validateRegistration() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      errorMessage = 'Todos os campos precisam ser preenchidos.';
      notifyListeners(); // Notifica que o estado foi alterado
      return false;
    }

    if (!_isValidEmail(email)) {
      errorMessage = 'Email inválido.';
      notifyListeners(); // Notifica que o estado foi alterado
      return false;
    }

    if (password != confirmPassword) {
      errorMessage = 'As senhas não coincidem.';
      notifyListeners(); // Notifica que o estado foi alterado
      return false;
    }

    errorMessage = ''; // Limpa a mensagem de erro
    notifyListeners(); // Notifica que o estado foi alterado
    return true;
  }

  // Função para validar o email
  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }
}
