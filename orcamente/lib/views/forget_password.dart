import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/controllers/forget_password_controller.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordController(),
      child: Scaffold(
        appBar: AppBar(title: Text('Recuperar Senha')),
        body: Consumer<ForgetPasswordController>(
          builder: (context, controller, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Usando o CustomTextField
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: 'E-mail',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16.0), // Espaçamento entre os campos

                  // Exibindo mensagem de erro, se houver
                  if (controller.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        controller.errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  // Botão de recuperação de senha
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.recoverPassword(); // Chama a função de recuperação
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Recuperar senha', style: TextStyle(fontSize: 16)),
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
