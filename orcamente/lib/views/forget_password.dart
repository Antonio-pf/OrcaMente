import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/controllers/forget_password_controller.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordController(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: true,
        ),
        body: Consumer<ForgotPasswordController>(
          builder: (context, controller, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/forgot_password.svg',
                    height: 150, 
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Esqueci a senha',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Não se preocupe isso acontece. Por favor insira o email da sua conta',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: controller.emailController,
                    hintText: 'E-mail',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16.0),
                  if (controller.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        controller.errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller
                              .recoverPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Recuperar senha',
                          style: TextStyle(fontSize: 16),
                        ),
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
