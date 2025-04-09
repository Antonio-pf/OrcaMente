// lib/controllers/piggy_bank_controller.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/piggy_bank.dart';

class PiggyBankController extends ChangeNotifier {
  PiggyBankModel piggyBank = PiggyBankModel(
    id: 'main',
    name: 'Meu Cofrinho',
    goal: 500,
    saved: 0,
  );

  final String _storageKey = 'piggy_bank_data';

  PiggyBankController() {
    load();
  }

  double get progress => (piggyBank.saved / piggyBank.goal).clamp(0, 1);

  void addAmount(double amount) {
    piggyBank.saved += amount;
    save();
    notifyListeners();
  }

  void reset() {
    piggyBank.saved = 0;
    save();
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, piggyBank.toJson());
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      piggyBank = PiggyBankModel.fromJson(data);
      notifyListeners();
    }
  }
}
