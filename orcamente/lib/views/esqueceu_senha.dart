import 'package:flutter/material.dart';

class EsqueceuSenhaPage extends StatefulWidget {
  @override
  _EsqueceuSenhaPageState createState() => _EsqueceuSenhaPageState();
}

class _EsqueceuSenhaPageState extends State<EsqueceuSenhaPage> {
  final TextEditingController _emailController = TextEditingController();

  void _recuperarSenha() {
    // adicionar logica para buscar no banco se existe email 
    print("recuperação de senha.");
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Senha')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 16.0,
              ), 
              child: ElevatedButton(
                onPressed: _recuperarSenha,
                child: const Text('Recuperar senha'),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
