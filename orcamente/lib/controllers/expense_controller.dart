import 'package:orcamente/models/expense.dart';

class ExpenseController {
  final List<Expense> _expenses = [];

  List<Expense> getExpensesByCategory(String category) {
    final now = DateTime.now();
    return _expenses.where((e) =>
      e.category == category &&
      e.date.month == now.month &&
      e.date.year == now.year
    ).toList();
  }

  void addExpense(String description, double value, String category) {
    _expenses.add(Expense(
      description: description,
      value: value,
      category: category,
      date: DateTime.now(),
    ));
  }
}
