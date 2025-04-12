import 'package:flutter/material.dart';

class GameStatsBar extends StatelessWidget {
  final int money;
  final int happiness;
  final int knowledge;

  const GameStatsBar({
    super.key,
    required this.money,
    required this.happiness,
    required this.knowledge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Dinheiro
          _buildStatItem(
            icon: Icons.attach_money,
            iconColor: Colors.green,
            label: "Dinheiro",
            value: "R\$ $money",
            valueColor: money < 300 ? Colors.red : Colors.green[700]!,
          ),
          
          // Felicidade
          _buildStatItem(
            icon: Icons.sentiment_satisfied_alt,
            iconColor: Colors.amber,
            label: "Felicidade",
            value: "$happiness%",
            valueColor: happiness < 30 ? Colors.red : Colors.amber[700]!,
          ),
          
          // Conhecimento
          _buildStatItem(
            icon: Icons.school,
            iconColor: Colors.blue,
            label: "Conhecimento",
            value: "$knowledge%",
            valueColor: Colors.blue[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
