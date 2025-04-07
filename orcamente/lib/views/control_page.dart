import 'package:flutter/material.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double totalIncome = 3000.0;
  double totalExpense = 700.0;

  void _simulateTransaction(String type) {
    setState(() {
      if (type == 'income') {
        totalIncome += 100.0;
      } else {
        totalExpense += 100.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cards = [
      {
        'type': 'income',
        'label': 'Entradas',
        'value': totalIncome,
        'color': Colors.green[100],
        'icon': Icons.arrow_downward,
        'iconColor': Colors.green,
      },
      {
        'type': 'expense',
        'label': 'Saídas',
        'value': totalExpense,
        'color': Colors.red[100],
        'icon': Icons.arrow_upward,
        'iconColor': Colors.red,
      },
    ];

    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: cards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final card = cards[index];

            return GestureDetector(
              onTap: () => _simulateTransaction(card['type']),
              child: Card(
                color: card['color'],
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        card['icon'],
                        color: card['iconColor'],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        card['label'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'R\$ ${card['value'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: card['iconColor'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
