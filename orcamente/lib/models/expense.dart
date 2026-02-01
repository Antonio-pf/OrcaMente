/// Enhanced Expense model with validation and business rules
class Expense {
  final String id; // id do documento no Firestore
  final String description;
  final double value;
  final DateTime date;
  final String category;
  final String? userId; // Added for better data isolation

  // Category constants
  static const String categoryAlimentacao = 'alimentacao';
  static const String categoryTransporte = 'transporte';
  static const String categoryLazer = 'lazer';
  static const String categoryOutros = 'outros';
  static const String categorySaude = 'saude';
  static const String categoryEducacao = 'educacao';
  static const String categoryMoradia = 'moradia';

  static const List<String> validCategories = [
    categoryAlimentacao,
    categoryTransporte,
    categoryLazer,
    categoryOutros,
    categorySaude,
    categoryEducacao,
    categoryMoradia,
  ];

  // Business rules constants
  static const double minValue = 0.01;
  static const double maxValue = 999999.99;
  static const int maxDescriptionLength = 200;

  Expense({
    required this.id,
    required this.description,
    required this.value,
    required this.date,
    required this.category,
    this.userId,
  });

  factory Expense.fromMap(String id, Map<String, dynamic> data) {
    try {
      return Expense(
        id: id,
        description: data['description'] as String? ?? '',
        value: (data['value'] as num?)?.toDouble() ?? 0.0,
        date:
            data['date'] is String
                ? DateTime.parse(data['date'] as String)
                : (data['date'] as DateTime),
        category: data['category'] as String? ?? categoryOutros,
        userId: data['userId'] as String?,
      );
    } catch (e) {
      throw FormatException('Invalid expense data: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'value': value,
      'date': date.toIso8601String(),
      'category': category,
      if (userId != null) 'userId': userId,
    };
  }

  /// Validate expense data
  bool isValid() {
    return description.isNotEmpty &&
        description.length <= maxDescriptionLength &&
        value >= minValue &&
        value <= maxValue &&
        validCategories.contains(category) &&
        !date.isAfter(DateTime.now().add(const Duration(days: 1)));
  }

  /// Get validation errors
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (description.isEmpty) {
      errors.add('Descrição é obrigatória');
    } else if (description.length > maxDescriptionLength) {
      errors.add(
        'Descrição deve ter no máximo $maxDescriptionLength caracteres',
      );
    }

    if (value < minValue) {
      errors.add('Valor deve ser maior que ${minValue.toStringAsFixed(2)}');
    } else if (value > maxValue) {
      errors.add('Valor deve ser menor que ${maxValue.toStringAsFixed(2)}');
    }

    if (!validCategories.contains(category)) {
      errors.add('Categoria inválida');
    }

    if (date.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      errors.add('Data não pode ser no futuro');
    }

    return errors;
  }

  /// Copy with method for immutability
  Expense copyWith({
    String? id,
    String? description,
    double? value,
    DateTime? date,
    String? category,
    String? userId,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      value: value ?? this.value,
      date: date ?? this.date,
      category: category ?? this.category,
      userId: userId ?? this.userId,
    );
  }

  /// Get category display name
  static String getCategoryDisplayName(String category) {
    switch (category) {
      case categoryAlimentacao:
        return 'Alimentação';
      case categoryTransporte:
        return 'Transporte';
      case categoryLazer:
        return 'Lazer';
      case categorySaude:
        return 'Saúde';
      case categoryEducacao:
        return 'Educação';
      case categoryMoradia:
        return 'Moradia';
      case categoryOutros:
        return 'Outros';
      default:
        return 'Outros';
    }
  }

  @override
  String toString() {
    return 'Expense(id: $id, description: $description, value: $value, category: $category, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Expense &&
        other.id == id &&
        other.description == description &&
        other.value == value &&
        other.date == date &&
        other.category == category &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        value.hashCode ^
        date.hashCode ^
        category.hashCode ^
        userId.hashCode;
  }
}
