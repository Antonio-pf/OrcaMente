import 'package:flutter/material.dart';

class PromotionWidget extends StatelessWidget {
  final String text;
  final int value;
  final bool collected;

  const PromotionWidget({
    super.key,
    required this.text,
    required this.value,
    this.collected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: collected ? 0.3 : 1.0,
      child: Column(
        children: [
          // Etiqueta com o texto educativo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Valor da promoção
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Text(
              "+R\$$value",
              style: TextStyle(
                color: Colors.green[900],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 5),
          
          // Item visual
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.lightbulb,
                color: Colors.yellow,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
