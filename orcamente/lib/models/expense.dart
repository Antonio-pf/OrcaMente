class Expense {
  final String? id;
  final String description;
  final double value;
  final String category; // 'essencial', 'lazer', 'outros' nesse momento
  final DateTime date;

  Expense({
    this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.date,
  });
}
