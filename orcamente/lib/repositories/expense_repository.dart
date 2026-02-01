import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orcamente/core/result.dart';
import 'package:orcamente/core/exceptions.dart';
import 'package:orcamente/services/firestore_service.dart';
import 'package:orcamente/services/auth_service.dart';
import 'package:orcamente/models/expense.dart';

/// Repository for expense data operations
/// Handles CRUD operations for expenses with Firestore
class ExpenseRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  ExpenseRepository({
    FirestoreService? firestoreService,
    AuthService? authService,
  }) : _firestoreService = firestoreService ?? FirestoreService(),
       _authService = authService ?? AuthService();

  static const String _expensesCollection = 'expenses';
  static const String _itemsSubcollection = 'items';

  /// Get current user ID or return error
  String? get _currentUserId => _authService.currentUserId;

  /// Fetch all expenses for current user
  /// Returns Result<List<Expense>> with expenses ordered by date (newest first)
  Future<Result<List<Expense>>> fetchExpenses() async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    final result = await _firestoreService.getSubcollection(
      collection: _expensesCollection,
      docId: uid,
      subcollection: _itemsSubcollection,
      queryBuilder:
          (collection) => collection.orderBy('date', descending: true),
    );

    return result.when(
      success: (docs) {
        try {
          final expenses =
              docs
                  .map(
                    (doc) => Expense.fromMap(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          return Success(expenses);
        } catch (e) {
          return Failure(
            'Erro ao processar despesas: $e',
            DataException.invalidFormat(),
          );
        }
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Get expenses filtered by category
  /// Returns Result<List<Expense>> with filtered expenses
  Future<Result<List<Expense>>> getExpensesByCategory(String category) async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    final result = await _firestoreService.getSubcollection(
      collection: _expensesCollection,
      docId: uid,
      subcollection: _itemsSubcollection,
      queryBuilder:
          (collection) => collection
              .where('category', isEqualTo: category)
              .orderBy('date', descending: true),
    );

    return result.when(
      success: (docs) {
        try {
          final expenses =
              docs
                  .map(
                    (doc) => Expense.fromMap(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          return Success(expenses);
        } catch (e) {
          return Failure(
            'Erro ao processar despesas: $e',
            DataException.invalidFormat(),
          );
        }
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Add new expense for current user
  /// Returns Result<Expense> with the created expense including generated ID
  Future<Result<Expense>> addExpense({
    required String description,
    required double value,
    required String category,
    DateTime? date,
  }) async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    final expense = Expense(
      id: '', // Will be filled by Firestore
      description: description,
      value: value,
      date: date ?? DateTime.now(),
      category: category,
    );

    final result = await _firestoreService.addToSubcollection(
      collection: _expensesCollection,
      docId: uid,
      subcollection: _itemsSubcollection,
      data: expense.toMap(),
    );

    return result.when(
      success:
          (docId) => Success(
            Expense(
              id: docId,
              description: expense.description,
              value: expense.value,
              date: expense.date,
              category: expense.category,
            ),
          ),
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Update existing expense
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> updateExpense({
    required String expenseId,
    String? description,
    double? value,
    String? category,
    DateTime? date,
  }) async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    final updateData = <String, dynamic>{};
    if (description != null) updateData['description'] = description;
    if (value != null) updateData['value'] = value;
    if (category != null) updateData['category'] = category;
    if (date != null) updateData['date'] = Timestamp.fromDate(date);

    if (updateData.isEmpty) {
      return const Failure(
        'Nenhum dado para atualizar',
        ValidationException('Nenhum dado fornecido para atualização'),
      );
    }

    try {
      await FirebaseFirestore.instance
          .collection(_expensesCollection)
          .doc(uid)
          .collection(_itemsSubcollection)
          .doc(expenseId)
          .update(updateData);

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        'Erro ao atualizar despesa: ${e.message}',
        DataException.saveFailed(),
      );
    } catch (e) {
      return Failure(
        'Erro ao atualizar despesa: $e',
        DataException.saveFailed(),
      );
    }
  }

  /// Delete expense
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> deleteExpense(String expenseId) async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    return await _firestoreService.deleteFromSubcollection(
      collection: _expensesCollection,
      docId: uid,
      subcollection: _itemsSubcollection,
      subdocId: expenseId,
    );
  }

  /// Stream expenses with real-time updates
  /// Returns Stream<List<Expense>> with real-time expense updates
  Stream<List<Expense>> watchExpenses() {
    final uid = _currentUserId;

    if (uid == null) {
      return Stream.value([]);
    }

    return _firestoreService
        .streamSubcollection(
          collection: _expensesCollection,
          docId: uid,
          subcollection: _itemsSubcollection,
          queryBuilder:
              (collection) => collection.orderBy('date', descending: true),
        )
        .map((docs) {
          try {
            return docs
                .map(
                  (doc) => Expense.fromMap(
                    doc.id,
                    doc.data() as Map<String, dynamic>,
                  ),
                )
                .toList();
          } catch (e) {
            // Return empty list on error
            return <Expense>[];
          }
        });
  }

  /// Stream expenses filtered by category
  /// Returns Stream<List<Expense>> with real-time updates for specific category
  Stream<List<Expense>> watchExpensesByCategory(String category) {
    final uid = _currentUserId;

    if (uid == null) {
      return Stream.value([]);
    }

    return _firestoreService
        .streamSubcollection(
          collection: _expensesCollection,
          docId: uid,
          subcollection: _itemsSubcollection,
          queryBuilder:
              (collection) => collection
                  .where('category', isEqualTo: category)
                  .orderBy('date', descending: true),
        )
        .map((docs) {
          try {
            return docs
                .map(
                  (doc) => Expense.fromMap(
                    doc.id,
                    doc.data() as Map<String, dynamic>,
                  ),
                )
                .toList();
          } catch (e) {
            return <Expense>[];
          }
        });
  }

  /// Calculate total expenses for current user
  /// Returns Result<double> with total amount
  Future<Result<double>> calculateTotal() async {
    final expensesResult = await fetchExpenses();

    return expensesResult.when(
      success: (expenses) {
        final total = expenses.fold<double>(
          0.0,
          (sum, expense) => sum + expense.value,
        );
        return Success(total);
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Calculate total by category
  /// Returns Result<double> with category total
  Future<Result<double>> calculateTotalByCategory(String category) async {
    final expensesResult = await getExpensesByCategory(category);

    return expensesResult.when(
      success: (expenses) {
        final total = expenses.fold<double>(
          0.0,
          (sum, expense) => sum + expense.value,
        );
        return Success(total);
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Get expenses for a specific date range
  /// Returns Result<List<Expense>> with expenses in date range
  Future<Result<List<Expense>>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    final result = await _firestoreService.getSubcollection(
      collection: _expensesCollection,
      docId: uid,
      subcollection: _itemsSubcollection,
      queryBuilder:
          (collection) => collection
              .where(
                'date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              )
              .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
              .orderBy('date', descending: true),
    );

    return result.when(
      success: (docs) {
        try {
          final expenses =
              docs
                  .map(
                    (doc) => Expense.fromMap(
                      doc.id,
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          return Success(expenses);
        } catch (e) {
          return Failure(
            'Erro ao processar despesas: $e',
            DataException.invalidFormat(),
          );
        }
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }
}
