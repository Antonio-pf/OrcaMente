import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Enhanced PiggyBank model with validation and business logic
class PiggyBankModel {
  final String id;
  final String name;
  final double goal;
  final double saved;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? goalDate;
  final String? description;

  // Business rules constants
  static const double minGoal = 1.0;
  static const double maxGoal = 9999999.99;
  static const double minSaved = 0.0;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 200;

  const PiggyBankModel({
    required this.id,
    required this.name,
    required this.goal,
    required this.saved,
    required this.createdAt,
    this.updatedAt,
    this.goalDate,
    this.description,
  });

  /// Calculate progress percentage (0-100)
  double get progress {
    if (goal <= 0) return 0.0;
    final percentage = (saved / goal) * 100;
    return percentage.clamp(0.0, 100.0);
  }

  /// Check if goal is reached
  bool get isGoalReached => saved >= goal;

  /// Calculate remaining amount to reach goal
  double get remainingAmount {
    final remaining = goal - saved;
    return remaining > 0 ? remaining : 0.0;
  }

  /// Check if goal date is overdue
  bool get isOverdue {
    if (goalDate == null || isGoalReached) return false;
    return DateTime.now().isAfter(goalDate!);
  }

  /// Calculate days remaining to goal date
  int? get daysRemaining {
    if (goalDate == null || isGoalReached) return null;
    final remaining = goalDate!.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'goal': goal,
      'saved': saved,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (goalDate != null) 'goalDate': goalDate!.toIso8601String(),
      if (description != null) 'description': description,
    };
  }

  /// Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'goal': goal,
      'saved': saved,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (goalDate != null) 'goalDate': Timestamp.fromDate(goalDate!),
      if (description != null) 'description': description,
    };
  }

  factory PiggyBankModel.fromMap(Map<String, dynamic> map) {
    try {
      return PiggyBankModel(
        id: map['id'] as String,
        name: map['name'] as String,
        goal: (map['goal'] as num).toDouble(),
        saved: (map['saved'] as num).toDouble(),
        createdAt:
            map['createdAt'] is String
                ? DateTime.parse(map['createdAt'] as String)
                : (map['createdAt'] as DateTime),
        updatedAt:
            map['updatedAt'] != null
                ? (map['updatedAt'] is String
                    ? DateTime.parse(map['updatedAt'] as String)
                    : (map['updatedAt'] as DateTime))
                : null,
        goalDate:
            map['goalDate'] != null
                ? (map['goalDate'] is String
                    ? DateTime.parse(map['goalDate'] as String)
                    : (map['goalDate'] as DateTime))
                : null,
        description: map['description'] as String?,
      );
    } catch (e) {
      throw FormatException('Invalid piggy bank data: $e');
    }
  }

  /// Create from Firestore DocumentSnapshot
  factory PiggyBankModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return PiggyBankModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      goal: (data['goal'] as num?)?.toDouble() ?? 0.0,
      saved: (data['saved'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      goalDate: (data['goalDate'] as Timestamp?)?.toDate(),
      description: data['description'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory PiggyBankModel.fromJson(String source) =>
      PiggyBankModel.fromMap(json.decode(source));

  /// Validate piggy bank data
  bool isValid() {
    return name.isNotEmpty &&
        name.length <= maxNameLength &&
        goal >= minGoal &&
        goal <= maxGoal &&
        saved >= minSaved &&
        saved <= maxGoal &&
        (description == null || description!.length <= maxDescriptionLength) &&
        (goalDate == null || goalDate!.isAfter(createdAt));
  }

  /// Get validation errors
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (name.isEmpty) {
      errors.add('Nome é obrigatório');
    } else if (name.length > maxNameLength) {
      errors.add('Nome deve ter no máximo $maxNameLength caracteres');
    }

    if (goal < minGoal) {
      errors.add('Meta deve ser maior que ${minGoal.toStringAsFixed(2)}');
    } else if (goal > maxGoal) {
      errors.add('Meta deve ser menor que ${maxGoal.toStringAsFixed(2)}');
    }

    if (saved < minSaved) {
      errors.add('Valor economizado não pode ser negativo');
    } else if (saved > maxGoal) {
      errors.add('Valor economizado excede o limite máximo');
    }

    if (description != null && description!.length > maxDescriptionLength) {
      errors.add(
        'Descrição deve ter no máximo $maxDescriptionLength caracteres',
      );
    }

    if (goalDate != null && goalDate!.isBefore(createdAt)) {
      errors.add('Data da meta deve ser posterior à data de criação');
    }

    return errors;
  }

  /// Copy with method for immutability
  PiggyBankModel copyWith({
    String? id,
    String? name,
    double? goal,
    double? saved,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? goalDate,
    String? description,
  }) {
    return PiggyBankModel(
      id: id ?? this.id,
      name: name ?? this.name,
      goal: goal ?? this.goal,
      saved: saved ?? this.saved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      goalDate: goalDate ?? this.goalDate,
      description: description ?? this.description,
    );
  }

  /// Add amount to saved
  PiggyBankModel addAmount(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be positive');
    }
    return copyWith(saved: saved + amount, updatedAt: DateTime.now());
  }

  /// Withdraw amount from saved
  PiggyBankModel withdrawAmount(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be positive');
    }
    if (amount > saved) {
      throw ArgumentError('Insufficient funds');
    }
    return copyWith(saved: saved - amount, updatedAt: DateTime.now());
  }

  @override
  String toString() {
    return 'PiggyBankModel(id: $id, name: $name, goal: $goal, saved: $saved, progress: ${progress.toStringAsFixed(1)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PiggyBankModel &&
        other.id == id &&
        other.name == name &&
        other.goal == goal &&
        other.saved == saved &&
        other.createdAt == createdAt &&
        other.goalDate == goalDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        goal.hashCode ^
        saved.hashCode ^
        createdAt.hashCode ^
        goalDate.hashCode;
  }
}
