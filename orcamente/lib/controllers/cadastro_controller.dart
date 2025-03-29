import 'package:flutter/material.dart';

class CadastroController {
  final TextEditingController nomeController;
  final TextEditingController emailController;
  final TextEditingController telefoneController;
  final TextEditingController senhaController;
  final TextEditingController confirmacaoSenhaController;

  CadastroController({
    required this.nomeController,
    required this.emailController,
    required this.telefoneController,
    required this.senhaController,
    required this.confirmacaoSenhaController,
  });

  bool validarCadastro() {
    String nome = nomeController.text;
    String email = emailController.text;
    String telefone = telefoneController.text;
    String senha = senhaController.text;
    String confirmacaoSenha = confirmacaoSenhaController.text;

    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty || confirmacaoSenha.isEmpty) {
      print("Todos os campos devem ser preenchidos.");
      return false;
    }

    if (senha != confirmacaoSenha) {
      print("As senhas não coincidem.");
      return false;
    }
    print("Cadastro realizado com sucesso!");
    return true;
  }
}
