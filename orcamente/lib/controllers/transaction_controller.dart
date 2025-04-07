import '../models/transaction_model.dart';

class TransactionController {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
  }

  double get balance {
    double total = 0;
    for (var t in _transactions) {
      if (t.type == TransactionType.income) {
        total += t.amount;
      } else {
        total -= t.amount;
      }
    }
    return total;
  }
}
