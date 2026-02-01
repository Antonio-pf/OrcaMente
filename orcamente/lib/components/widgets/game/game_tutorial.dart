import 'package:flutter/material.dart';

class GameTutorial extends StatelessWidget {
  final VoidCallback onDismiss;

  const GameTutorial({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Como Jogar",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),

              _buildTutorialItem(
                icon: Icons.touch_app,
                title: "Toque na tela para pular",
                description:
                    "Toque duas vezes rapidamente para pular mais alto",
              ),

              const SizedBox(height: 16),

              _buildTutorialItem(
                icon: Icons.lightbulb,
                title: "Colete dicas financeiras",
                description: "Elas aumentam seu dinheiro e conhecimento",
              ),

              const SizedBox(height: 16),

              _buildTutorialItem(
                icon: Icons.money_off,
                title: "Evite as dívidas",
                description: "Elas reduzem seu dinheiro e felicidade",
              ),

              const SizedBox(height: 16),

              _buildTutorialItem(
                icon: Icons.speed,
                title: "O jogo acelera com o tempo",
                description: "Quanto mais pontos, maior a dificuldade",
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: onDismiss,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "COMEÇAR",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.green, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
