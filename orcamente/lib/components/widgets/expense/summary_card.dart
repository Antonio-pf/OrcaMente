import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double totalAmount;
  final List<String> categories;
  final Map<String, String> categoryLabels;
  final Map<String, Color> categoryColors;
  final double Function(String category) getTotalExpense;
  final double Function(String category) getCategoryPercentage;

  const SummaryCard({
    Key? key,
    required this.totalAmount,
    required this.categories,
    required this.categoryLabels,
    required this.categoryColors,
    required this.getTotalExpense,
    required this.getCategoryPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Extrato do Mês',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[700],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'R\$ ${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Categorias com progresso
            for (String category in categories) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoryLabels[category]!,
                    style: TextStyle(
                      color: categoryColors[category],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'R\$ ${getTotalExpense(category).toStringAsFixed(2)} '
                    '(${getCategoryPercentage(category).toStringAsFixed(0)}%)',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: getCategoryPercentage(category) / 100,
                backgroundColor: Colors.grey[200],
                color: categoryColors[category],
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 12),
            ],

            const Divider(),
            const SizedBox(height: 8),

            // Comparação com mês anterior (estático por enquanto)
            Row(
              children: [
                Icon(
                  Icons.trending_down,
                  size: 16,
                  color: Colors.green[700],
                ),
                const SizedBox(width: 8),
                Text(
                  '15% menor que o mês anterior',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
