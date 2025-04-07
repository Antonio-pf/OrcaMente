import 'package:flutter/material.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/login_page.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Progresso do Usuário',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.grey[300],
            color: CustomTheme.primaryColor,
            minHeight: 10,
          ),
          const SizedBox(height: 12),
          const Text("Você completou 60% dos módulos disponíveis."),
          const Spacer(),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Sair"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
