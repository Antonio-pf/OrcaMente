import 'package:orcamente/models/expense.dart';

class ExpenseController {
  final List<Expense> _expenses = [
    Expense(
      description: 'tes23',
      value: 3.0,
      date: DateTime.now(),
      category: 'essencial',
    ),
    Expense(
      description: 'asd',
      value: 123.0,
      date: DateTime.now(),
      category: 'lazer',
    ),
  ];
  
  // Para armazenar a última despesa removida (para funcionalidade de desfazer)
  Expense? _lastRemovedExpense;
  int? _lastRemovedIndex;

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  void addExpense(String description, double value, String category) {
    final newExpense = Expense(
      description: description,
      value: value,
      date: DateTime.now(),
      category: category,
    );
    
    _expenses.add(newExpense);
  }
  
  void removeExpense(int index, String category) {
    // Encontrar o índice global na lista completa de despesas
    final expenses = getExpensesByCategory(category);
    if (index >= 0 && index < expenses.length) {
      final expenseToRemove = expenses[index];
      final globalIndex = _expenses.indexOf(expenseToRemove);
      
      if (globalIndex >= 0) {
        _lastRemovedExpense = _expenses[globalIndex];
        _lastRemovedIndex = globalIndex;
        _expenses.removeAt(globalIndex);
      }
    }
  }
  
  void undoRemoveExpense() {
    if (_lastRemovedExpense != null && _lastRemovedIndex != null) {
      _expenses.insert(_lastRemovedIndex!, _lastRemovedExpense!);
      _lastRemovedExpense = null;
      _lastRemovedIndex = null;
    }
  }
}
