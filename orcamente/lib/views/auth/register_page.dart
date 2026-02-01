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
      child: Consumer<RegisterController>(
        builder: (context, controller, child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  automaticallyImplyLeading: true,
                ),
                body: SingleChildScrollView(
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
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
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
                        onChanged: (text) {
                          controller.clearErrorMessage();
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: 'E-mail',
                        icon: Icons.email,
                        onChanged: (text) {
                          controller.clearErrorMessage();
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.phoneController,
                        hintText: 'Telefone',
                        icon: Icons.phone,
                        onChanged: (text) {
                          controller.clearErrorMessage();
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.passwordController,
                        hintText: 'Senha',
                        icon: Icons.lock,
                        isPassword: true,
                        onChanged: (text) {
                          controller.clearErrorMessage();
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.confirmPasswordController,
                        hintText: 'Confirmar Senha',
                        icon: Icons.lock,
                        isPassword: true,
                        onChanged: (text) {
                          controller.clearErrorMessage();
                        },
                      ),
                      if (controller.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.errorMessage,
                                    style: TextStyle(
                                      color: Colors.red.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              controller.isLoading
                                  ? null
                                  : () async {
                                    FocusScope.of(context).unfocus();

                                    final success =
                                        await controller.registerUser();

                                    if (success) {
                                      if (!context.mounted) return;

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Cadastro realizado com sucesso!',
                                          ),
                                          backgroundColor:
                                              CustomTheme.successColor,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );

                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );

                                      if (!context.mounted) return;

                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/login',
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              controller.isLoading
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Cadastrar',
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Loading Overlay
              if (controller.isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Criando conta...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
