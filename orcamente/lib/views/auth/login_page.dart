import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/components/common/gradient_background.dart';
import 'package:orcamente/components/common/standard_card.dart';
import 'package:orcamente/components/common/standard_button.dart';
import 'package:orcamente/controllers/login_controller.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
          return Stack(
            children: [
              Scaffold(
                body: GradientBackground(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          
                          // App logo
                          Hero(
                            tag: 'app_logo',
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    CustomTheme.primaryColor,
                                    CustomTheme.primaryDark,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: CustomTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.attach_money_rounded,
                                color: CustomTheme.neutralWhite,
                                size: 50,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Welcome text
                          const Text(
                            'Bem-vindo de volta!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Entre com suas credenciais para continuar',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF616161),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Login form card
                          StandardCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  controller: loginController.emailController,
                                  hintText: 'E-mail',
                                  icon: Icons.email_outlined,
                                  onChanged: (text) {
                                    loginController.clearErrorMessage();
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: loginController.passwordController,
                                  hintText: 'Senha',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  onChanged: (text) {
                                    loginController.clearErrorMessage();
                                  },
                                ),
                                
                                if (loginController.errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              loginController.errorMessage,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                
                                const SizedBox(height: 12),
                                
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/forget-password');
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: CustomTheme.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: const Text(
                                      'Esqueceu a senha?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                SizedBox(
                                  width: double.infinity,
                                  child: StandardButton(
                                    text: 'Entrar',
                                    isLoading: loginController.isLoading,
                                    onPressed:
                                        loginController.isLoading
                                            ? null
                                            : () {
                                              loginController.handleLogin(context);
                                            },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Primeira vez aqui?",
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: CustomTheme.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Cadastre-se agora',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // About link
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/about');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: CustomTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Sobre',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Loading Overlay
              if (loginController.isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: StandardCard(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CustomTheme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                CustomTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Autenticando...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ],
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
