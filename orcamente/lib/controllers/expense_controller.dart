import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orcamente/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Expense> _expenses = [];

  Expense? _lastRemovedExpense;
  int? _lastRemovedIndex;

  String? get _userId => _auth.currentUser?.uid;

  Future<List<Expense>> fetchExpenses() async {
    if (_userId == null) throw Exception('Usuário não autenticado');

    final querySnapshot = await _firestore
        .collection('expenses')
        .doc(_userId)
        .collection('items')
        .orderBy('date', descending: true)
        .get();

    _expenses = querySnapshot.docs
        .map((doc) => Expense.fromMap(doc.id, doc.data()))
        .toList();

    return _expenses;
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  Future<void> addExpense(String description, double value, String category) async {
    if (_userId == null) throw Exception('Usuário não autenticado');

    final newExpense = Expense(
      id: '', // será preenchido pelo Firestore
      description: description,
      value: value,
      date: DateTime.now(),
      category: category,
    );

    final docRef = await _firestore
        .collection('expenses')
        .doc(_userId)
        .collection('items')
        .add(newExpense.toMap());

    _expenses.insert(
      0,
      Expense(
        id: docRef.id,
        description: newExpense.description,
        value: newExpense.value,
        date: newExpense.date,
        category: newExpense.category,
      ),
    );
  }

  Future<void> removeExpense(String expenseId) async {
    if (_userId == null) throw Exception('Usuário não autenticado');

    final index = _expenses.indexWhere((e) => e.id == expenseId);
    if (index == -1) return;

    _lastRemovedExpense = _expenses[index];
    _lastRemovedIndex = index;

    _expenses.removeAt(index);

    await _firestore
        .collection('expenses')
        .doc(_userId)
        .collection('items')
        .doc(expenseId)
        .delete();
  }

  Future<void> undoRemoveExpense() async {
    if (_lastRemovedExpense == null || _userId == null) return;

    final expense = _lastRemovedExpense!;
    final docRef = await _firestore
        .collection('expenses')
        .doc(_userId)
        .collection('items')
        .add(expense.toMap());

    _expenses.insert(
      _lastRemovedIndex!,
      Expense(
        id: docRef.id,
        description: expense.description,
        value: expense.value,
        date: expense.date,
        category: expense.category,
      ),
    );

    _lastRemovedExpense = null;
    _lastRemovedIndex = null;
  }
}