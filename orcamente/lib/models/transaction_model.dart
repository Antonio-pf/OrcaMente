/// Transaction type enumeration
enum TransactionType {
  income,
  expense;

  /// Convert to string for storage
  String toJson() => name;

  /// Create from string
  static TransactionType fromJson(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionType.expense,
    );
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case TransactionType.income:
        return 'Receita';
      case TransactionType.expense:
        return 'Despesa';
    }
  }
}

/// Enhanced Transaction model with validation and serialization
class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? description;
  final String? userId;

  // Business rules constants
  static const double minAmount = 0.01;
  static const double maxAmount = 999999999.99;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
    this.userId,
  });

  /// Create from Map (Firestore deserialization)
  factory TransactionModel.fromMap(String id, Map<String, dynamic> data) {
    try {
      return TransactionModel(
        id: id,
        title: data['title'] as String? ?? '',
        amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
        type: TransactionType.fromJson(data['type'] as String? ?? 'expense'),
        category: data['category'] as String? ?? '',
        date: data['date'] is String
            ? DateTime.parse(data['date'] as String)
            : (data['date'] as DateTime),
        description: data['description'] as String?,
        userId: data['userId'] as String?,
      );
    } catch (e) {
      throw FormatException('Invalid transaction data: $e');
    }
  }

  /// Convert to Map for Firestore serialization
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'type': type.toJson(),
      'category': category,
      'date': date.toIso8601String(),
      if (description != null) 'description': description,
      if (userId != null) 'userId': userId,
    };
  }

  /// Validate transaction data
  bool isValid() {
    return title.isNotEmpty &&
        title.length <= maxTitleLength &&
        amount >= minAmount &&
        amount <= maxAmount &&
        category.isNotEmpty &&
        (description == null || description!.length <= maxDescriptionLength) &&
        !date.isAfter(DateTime.now().add(const Duration(days: 1)));
  }

  /// Get validation errors
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (title.isEmpty) {
      errors.add('Título é obrigatório');
    } else if (title.length > maxTitleLength) {
      errors.add('Título deve ter no máximo $maxTitleLength caracteres');
    }

    if (amount < minAmount) {
      errors.add('Valor deve ser maior que ${minAmount.toStringAsFixed(2)}');
    } else if (amount > maxAmount) {
      errors.add('Valor deve ser menor que ${maxAmount.toStringAsFixed(2)}');
    }

    if (category.isEmpty) {
      errors.add('Categoria é obrigatória');
    }

    if (description != null && description!.length > maxDescriptionLength) {
      errors.add(
          'Descrição deve ter no máximo $maxDescriptionLength caracteres');
    }

    if (date.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      errors.add('Data não pode ser no futuro');
    }

    return errors;
  }

  /// Copy with method for immutability
  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
    String? description,
    String? userId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, type: ${type.displayName}, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.type == type &&
        other.category == category &&
        other.date == date &&
        other.description == description &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        amount.hashCode ^
        type.hashCode ^
        category.hashCode ^
        date.hashCode ^
        description.hashCode ^
        userId.hashCode;
  }
}
