import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController = TextEditingController();

  String errorMessage = '';

  bool _validarCadastro() {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String telefone = _telefoneController.text;
    String senha = _senhaController.text;
    String confirmaSenha = _confirmaSenhaController.text;

    if (nome.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty || confirmaSenha.isEmpty) {
      setState(() {
        errorMessage = 'Todos os campos precisam ser preenchidos.';
      });
      return false;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        errorMessage = 'Email inválido.';
      });
      return false;
    }

    if (senha != confirmaSenha) {
      setState(() {
        errorMessage = 'As senhas não coincidem.';
      });
      return false;
    }

    setState(() {
      errorMessage = ''; 
    });

    print('Cadastro realizado com sucesso!');
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: _confirmaSenhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_validarCadastro()) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
