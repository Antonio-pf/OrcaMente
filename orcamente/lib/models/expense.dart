class Expense {
  final String description;
  final double value;
  final String category; // 'essencial', 'lazer', 'outros' nesse momento
  final DateTime date;

  Expense({
    required this.description,
    required this.value,
    required this.category,
    required this.date,
  });
}
