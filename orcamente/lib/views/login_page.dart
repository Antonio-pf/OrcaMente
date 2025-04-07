import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/controllers/login_controller.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => LoginController(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
          ),
      child: Consumer<LoginController>(
        builder: (context, loginController, child) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child:  Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: CustomTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.attach_money_rounded,
                  color: CustomTheme.neutralWhite,
                  size: 40,
                ),
              ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Digite email e senha para continuar',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: loginController.emailController,
                    hintText: 'E-mail',
                    icon: Icons.email,
                    onChanged: (text) {
                      loginController.clearErrorMessage();
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: loginController.passwordController,
                    hintText: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                    onChanged: (text) {
                      loginController.clearErrorMessage();
                    },
                  ),
                  if (loginController.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        loginController.errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forget-password');
                      },
                      child: Text('Esqueceu a senha?'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                    loginController.handleLogin(context);
                  },

                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Primeira vez aqui?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Cadastre-se agora',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(), 
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/about');
                    },
                    child: const Text(
                      'Sobre',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
