import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orcamente/controllers/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Configurações', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Modo Escuro'),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeController.toggleTheme(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
