class Expense {
  final String id; // id do documento no Firestore
  final String description;
  final double value;
  final DateTime date;
  final String category;

  Expense({
    required this.id,
    required this.description,
    required this.value,
    required this.date,
    required this.category,
  });

  factory Expense.fromMap(String id, Map<String, dynamic> data) {
    return Expense(
      id: id,
      description: data['description'] ?? '',
      value: (data['value'] ?? 0).toDouble(),
      date: DateTime.parse(data['date']),
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'value': value,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}