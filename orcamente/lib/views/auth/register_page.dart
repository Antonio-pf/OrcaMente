import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/controllers/register_controller.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:provider/provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  late RegisterController controller;

  @override
  void initState() {
    super.initState();
    controller = RegisterController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterController>.value(
      value: controller,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: true,
        ),
        body: Consumer<RegisterController>(
          builder: (context, controller, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/svg/register.svg',
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cadastre-se',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Use suas próprias informações',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: 'Nome',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: 'E-mail',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.phoneController,
                    hintText: 'Telefone',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.passwordController,
                    hintText: 'Senha',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.confirmPasswordController,
                    hintText: 'Confirmar Senha',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  if (controller.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        controller.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              final success = await controller.registerUser();

                              if (success) {
                                if (!context.mounted) return;

                                // Espera 1 segundo antes de mostrar o snackbar
                                await Future.delayed(const Duration(seconds: 1));

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Cadastro realizado com sucesso!'),
                                    backgroundColor: CustomTheme.successColor,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );

                                // Espera o snackbar sumir (3 segundos)
                                await Future.delayed(const Duration(seconds: 3));

                                if (!context.mounted) return;

                                Navigator.pushReplacementNamed(context, '/login');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Cadastrar',
                              style: TextStyle(fontSize: 16),
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
