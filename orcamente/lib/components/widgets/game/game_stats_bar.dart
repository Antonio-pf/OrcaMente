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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat(Icons.attach_money, money, Colors.green),
            _buildStat(Icons.sentiment_satisfied, happiness, Colors.orange),
            _buildStat(Icons.school, knowledge, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, int value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
