import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';
import '../core/result.dart';

class ExpenseController extends ChangeNotifier {
  final ExpenseRepository _repository;

  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  Expense? _lastRemovedExpense;
  int? _lastRemovedIndex;

  ExpenseController(this._repository);

  // Getters
  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Fetch all expenses for the current user
  Future<Result<List<Expense>>> fetchExpenses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchExpenses();

    result.when(
      success: (expenses) {
        _expenses = expenses;
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Get expenses filtered by category
  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  /// Get expenses within a date range
  Future<Result<List<Expense>>> fetchExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getExpensesByDateRange(
      startDate: startDate,
      endDate: endDate,
    );

    result.when(
      success: (expenses) {
        _expenses = expenses;
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Add a new expense
  Future<Result<void>> addExpense(
    String description,
    double value,
    String category,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.addExpense(
      description: description,
      value: value,
      category: category,
    );

    await result.when(
      success: (_) async {
        // Refresh expenses after adding - AWAIT to ensure list is updated
        await fetchExpenses();
      },
      failure: (error, exception) async {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result.map((_) => null);
  }

  /// Update an existing expense
  Future<Result<void>> updateExpense(Expense expense) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.updateExpense(
      expenseId: expense.id,
      description: expense.description,
      value: expense.value,
      category: expense.category,
      date: expense.date,
    );

    result.when(
      success: (_) {
        // Update local list
        final index = _expenses.indexWhere((e) => e.id == expense.id);
        if (index != -1) {
          _expenses[index] = expense;
        }
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Remove an expense (with undo capability)
  Future<Result<void>> removeExpense(String expenseId) async {
    final index = _expenses.indexWhere((e) => e.id == expenseId);
    if (index == -1) {
      return const Failure('Despesa não encontrada');
    }

    // Save for undo
    _lastRemovedExpense = _expenses[index];
    _lastRemovedIndex = index;

    // Remove from local list immediately for better UX
    _expenses.removeAt(index);
    notifyListeners();

    final result = await _repository.deleteExpense(expenseId);

    result.when(
      success: (_) {
        // Successfully deleted
      },
      failure: (error, exception) {
        // Restore on error
        if (_lastRemovedExpense != null && _lastRemovedIndex != null) {
          _expenses.insert(_lastRemovedIndex!, _lastRemovedExpense!);
        }
        _errorMessage = error;
        notifyListeners();
      },
    );

    return result;
  }

  /// Undo the last removed expense
  Future<Result<void>> undoRemoveExpense() async {
    if (_lastRemovedExpense == null) {
      return const Failure('Nenhuma despesa para desfazer');
    }

    final expense = _lastRemovedExpense!;

    final result = await _repository.addExpense(
      description: expense.description,
      value: expense.value,
      category: expense.category,
      date: expense.date,
    );

    await result.when(
      success: (_) async {
        // Refresh to get the new ID - AWAIT to ensure list is updated before clearing undo state
        await fetchExpenses();
        _lastRemovedExpense = null;
        _lastRemovedIndex = null;
      },
      failure: (error, exception) async {
        _errorMessage = error;
        notifyListeners();
      },
    );

    return result.map((_) => null);
  }

  /// Calculate total expenses
  double get totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.value);
  }

  /// Calculate total by category
  double getTotalByCategory(String category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, expense) => sum + expense.value);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Stream expenses (real-time updates)
  Stream<List<Expense>> watchExpenses() {
    return _repository.watchExpenses();
  }
}
