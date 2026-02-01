import 'package:flutter/material.dart';
import '../models/piggy_bank.dart';
import '../repositories/piggy_bank_repository.dart';
import '../core/result.dart';

class PiggyBankController extends ChangeNotifier {
  final PiggyBankRepository _repository;

  PiggyBankModel piggyBank = PiggyBankModel(
    id: 'main',
    name: 'Meu Cofrinho',
    goal: 500,
    saved: 0,
    createdAt: DateTime.now(),
  );

  bool _isLoading = false;
  String? _errorMessage;

  PiggyBankController(this._repository) {
    _initialize();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  double get progress => (piggyBank.saved / piggyBank.goal).clamp(0, 1);

  /// Initialize and load piggy bank data
  Future<void> _initialize() async {
    await load();
  }

  /// Add amount to piggy bank
  Future<Result<void>> addAmount(double amount) async {
    if (amount <= 0) {
      return const Failure('O valor deve ser maior que zero');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Update local state immediately for better UX using model method
    final oldPiggyBank = piggyBank;
    try {
      piggyBank = piggyBank.addAmount(amount);
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      return Failure(e.toString());
    }

    final result = await _repository.updatePiggyBank(piggyBank);

    result.when(
      success: (_) {
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        // Revert on error
        piggyBank = oldPiggyBank;
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Reset piggy bank saved amount to zero
  Future<Result<void>> reset() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final oldPiggyBank = piggyBank;
    piggyBank = piggyBank.copyWith(
      saved: 0,
      updatedAt: DateTime.now(),
    );
    notifyListeners();

    final result = await _repository.updatePiggyBank(piggyBank);

    result.when(
      success: (_) {
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        // Revert on error
        piggyBank = oldPiggyBank;
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Update piggy bank goal
  Future<Result<void>> updateGoal(double newGoal) async {
    if (newGoal <= 0) {
      return const Failure('A meta deve ser maior que zero');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final oldPiggyBank = piggyBank;
    piggyBank = piggyBank.copyWith(
      goal: newGoal,
      updatedAt: DateTime.now(),
    );
    notifyListeners();

    final result = await _repository.updatePiggyBank(piggyBank);

    result.when(
      success: (_) {
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        // Revert on error
        piggyBank = oldPiggyBank;
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Update piggy bank name
  Future<Result<void>> updateName(String newName) async {
    if (newName.trim().isEmpty) {
      return const Failure('O nome não pode estar vazio');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final oldPiggyBank = piggyBank;
    piggyBank = piggyBank.copyWith(
      name: newName,
      updatedAt: DateTime.now(),
    );
    notifyListeners();

    final result = await _repository.updatePiggyBank(piggyBank);

    result.when(
      success: (_) {
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        // Revert on error
        piggyBank = oldPiggyBank;
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Load piggy bank data from repository
  Future<Result<void>> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getPiggyBank();

    result.when(
      success: (loadedPiggyBank) {
        piggyBank = loadedPiggyBank;
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result.map((_) => null);
  }

  /// Check if goal is reached
  bool get isGoalReached => piggyBank.saved >= piggyBank.goal;

  /// Get remaining amount to reach goal
  double get remainingToGoal => (piggyBank.goal - piggyBank.saved).clamp(0, double.infinity);

  /// Get progress percentage (0-100)
  double get progressPercentage => (progress * 100).clamp(0, 100);

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
