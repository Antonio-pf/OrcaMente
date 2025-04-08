import 'package:flutter/material.dart';

class Obstacle extends StatelessWidget {
  final String tipoDivida;

  const Obstacle({
    super.key,
    required this.tipoDivida,
  });

  IconData _getIconForTipo() {
    switch (tipoDivida.toLowerCase()) {
      case 'lanche':
        return Icons.fastfood;
      case 'tênis':
        return Icons.shopping_bag;
      case 'streaming':
        return Icons.tv;
      case 'cartão':
        return Icons.credit_card;
      case 'conta de luz':
        return Icons.lightbulb;
      case 'empréstimo':
        return Icons.attach_money;
      case 'assinatura':
        return Icons.subscriptions;
      case 'parcelado':
        return Icons.payments;
      default:
        return Icons.warning;
    }
  }

 @override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.green, width: 2), // Borda visível
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Icon(
          _getIconForTipo(),
          color: Colors.red,
          size: 30,
        ),
        const SizedBox(height: 4),
        Text(
          tipoDivida,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

}
