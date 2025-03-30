import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/controllers/register_controller.dart';
import 'package:provider/provider.dart'; // Importando provider

class CadastroPage extends StatelessWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterController(),
      child: Scaffold(
        appBar: AppBar(title: Text('Cadastro de Usuário')),
        body: Consumer<RegisterController>(
          builder: (context, controller, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: 'Nome',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: 'E-mail',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    controller: controller.phoneController,
                    hintText: 'Telefone',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    controller: controller.passwordController,
                    hintText: 'Senha',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    controller: controller.confirmPasswordController,
                    hintText: 'Confirmar Senha',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  if (controller.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: AnimatedOpacity(
                        opacity: controller.errorMessage.isEmpty ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          controller.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.validateRegistration()) {
                            Navigator.pushNamed(context, '/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cadastrar', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
