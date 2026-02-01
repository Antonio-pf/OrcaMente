import 'package:flutter/material.dart';

class Obstacle extends StatelessWidget {
  final String tipoDivida;
  final int valor;

  const Obstacle({super.key, required this.tipoDivida, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Etiqueta com o tipo de dívida
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Text(
            tipoDivida,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Valor da dívida
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
          ),
          child: Text(
            "R\$$valor",
            style: TextStyle(
              color: Colors.red[900],
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 5),

        // Obstáculo visual
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red[800],
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
            Icon(Icons.money_off, color: Colors.white, size: 24),
          ],
        ),
      ],
    );
  }
}
