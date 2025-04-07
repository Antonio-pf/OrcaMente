enum TransactionType { income, expense }

class TransactionModel {
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });
}
