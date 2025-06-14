import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

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
  print('registerUser iniciado');

  if (!validateRegistration()) {
    print('Validação falhou: $errorMessage');
    return false;
  }

  _setLoading(true);
  _setError('');

  try {
    print('Tentando criar usuário no FirebaseAuth');
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
    print('Usuário criado: ${userCredential.user?.uid}');

    print('Salvando dados no Firestore');
    final stopwatch = Stopwatch()..start();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
          'nome': nameController.text.trim(),
          'email': emailController.text.trim(),
          'telefone': phoneController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

    stopwatch.stop();
    print(
      'Dados salvos no Firestore em ${stopwatch.elapsedMilliseconds} ms',
    );

    return true;
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException: ${e.code}');
    switch (e.code) {
      case 'email-already-in-use':
        _setError('Este e-mail já está sendo usado.');
        break;
      case 'invalid-email':
        _setError('Email inválido.');
        break;
      case 'operation-not-allowed':
        _setError('Operação não permitida.');
        break;
      case 'weak-password':
        _setError('Senha muito fraca.');
        break;
      default:
        _setError('Erro: ${e.message}');
    }
    return false;
  } catch (e) {
    print('Erro inesperado: $e');
    _setError('Erro inesperado.');
    return false;
  } finally {
    _setLoading(false);
  }
}

}
