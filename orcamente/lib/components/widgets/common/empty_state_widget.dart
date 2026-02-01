import 'package:flutter/material.dart';

/// Reusable empty state widget with consistent styling
/// Used throughout the app for empty data states
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel = 'Adicionar',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for expenses
class EmptyExpensesWidget extends StatelessWidget {
  final VoidCallback? onAddExpense;

  const EmptyExpensesWidget({Key? key, this.onAddExpense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Nenhum gasto registrado',
      message: 'Comece a registrar seus gastos para ter controle financeiro',
      icon: Icons.receipt_long,
      onAction: onAddExpense,
      actionLabel: 'Adicionar primeiro gasto',
    );
  }
}

/// Empty state for search results
class EmptySearchWidget extends StatelessWidget {
  final String searchQuery;

  const EmptySearchWidget({Key? key, required this.searchQuery})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Nenhum resultado encontrado',
      message: 'Não encontramos nada para "$searchQuery"',
      icon: Icons.search_off,
    );
  }
}

/// Empty state for generic lists
class EmptyListWidget extends StatelessWidget {
  final String title;
  final String? message;

  const EmptyListWidget({Key? key, this.title = 'Lista vazia', this.message})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title,
      message: message,
      icon: Icons.list_alt,
    );
  }
}
