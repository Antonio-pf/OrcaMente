import 'package:flutter/material.dart';
import 'package:orcamente/controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  late final LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController(
      emailController: _emailController,
      passwordController: _senhaController,
    );
  }

  void _login() {
    bool isValid = _loginController.validateLogin();

    setState(() {
      // atualiza a message error
    });

    if (isValid) {
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      // A mensagem de erro já foi atualizada automaticamente
      // Nenhuma ação extra é necessária aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo_orcamente.png', height: 100),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),

            if (_loginController.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _loginController.errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),

            Container(
              margin: const EdgeInsets.only(
                top: 16.0,
              ), 
              child: ElevatedButton(
                onPressed: _login,
                child: const Text('Entrar'),
              ),
            ),

            SizedBox(
              height: 16,
            ), 

            Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, 
              crossAxisAlignment:
                  CrossAxisAlignment
                      .center, 
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/register',
                    ); 
                  },
                  child: const Text('Não tem conta? Cadastre-se'),
                ),
                SizedBox(height: 8), 
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/forget-password',
                    ); 
                  },
                  child: const Text('Esqueceu a senha?'),
                ),
              ],
            ),
          ],  
        ),
      ),
    );
  }
}
