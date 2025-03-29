import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmacaoSenhaController = TextEditingController();

  void _cadastro() {
    // add logica de cadastro
    print("Usuário cadastrado com sucesso!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuário')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: _confirmacaoSenhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirmar Senha'),
            ),
           Container(
              margin: const EdgeInsets.only(
                top: 16.0,
              ),
              child: ElevatedButton(
                onPressed: _cadastro,
                child: const Text('Cadastrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
