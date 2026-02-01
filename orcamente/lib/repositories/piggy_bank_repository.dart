import 'package:orcamente/core/result.dart';
import 'package:orcamente/core/exceptions.dart';
import 'package:orcamente/services/firestore_service.dart';
import 'package:orcamente/services/auth_service.dart';
import 'package:orcamente/models/piggy_bank.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for piggy bank data operations
/// Handles both Firestore and local storage (SharedPreferences)
/// Supports migration from local to cloud storage
class PiggyBankRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  PiggyBankRepository({
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _authService = authService ?? AuthService();

  static const String _piggyBanksCollection = 'piggy_banks';
  
  // SharedPreferences keys (for backward compatibility)
  static const String _localCurrentAmountKey = 'piggyBankCurrentAmount';
  static const String _localGoalKey = 'piggyBankGoal';

  /// Get current user ID or return error
  String? get _currentUserId => _authService.currentUserId;

  /// Get piggy bank data from Firestore
  /// Returns Result<PiggyBankModel> with piggy bank data
  Future<Result<PiggyBankModel>> getPiggyBank() async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    // Try to get from Firestore first
    final result = await _firestoreService.getDocumentData(
      collection: _piggyBanksCollection,
      docId: uid,
    );

    return result.when(
      success: (data) {
        try {
          final piggyBank = PiggyBankModel.fromMap(data);
          return Success(piggyBank);
        } catch (e) {
          return Failure(
            'Erro ao processar dados do cofrinho: $e',
            DataException.invalidFormat(),
          );
        }
      },
      failure: (error, exception) async {
        // If not found in Firestore, try to migrate from SharedPreferences
        if (exception is DataException && exception.code == 'not-found') {
          return await _migrateFromLocalStorage();
        }
        return Failure(error, exception);
      },
    );
  }

  /// Update piggy bank data in Firestore
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> updatePiggyBank(PiggyBankModel piggyBank) async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    final data = piggyBank.toMap();
    data['updatedAt'] = DateTime.now().toIso8601String();

    return await _firestoreService.setDocument(
      collection: _piggyBanksCollection,
      docId: uid,
      data: data,
      merge: true,
    );
  }

  /// Add money to piggy bank
  /// Returns Result<PiggyBankModel> with updated piggy bank
  Future<Result<PiggyBankModel>> addMoney(double amount) async {
    if (amount <= 0) {
      return Failure(
        'Valor deve ser maior que zero',
        ValidationException.invalidFormat('amount'),
      );
    }

    final piggyBankResult = await getPiggyBank();

      return await piggyBankResult.when(
      success: (piggyBank) async {
        final updatedPiggyBank = PiggyBankModel(
          id: piggyBank.id,
          name: piggyBank.name,
          goal: piggyBank.goal,
          saved: piggyBank.saved + amount,
          createdAt: piggyBank.createdAt,
          updatedAt: DateTime.now(),
        );

        final updateResult = await updatePiggyBank(updatedPiggyBank);

        return updateResult.when(
          success: (_) => Success(updatedPiggyBank),
          failure: (error, exception) => Failure(error, exception),
        );
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Withdraw money from piggy bank
  /// Returns Result<PiggyBankModel> with updated piggy bank
  Future<Result<PiggyBankModel>> withdrawMoney(double amount) async {
    if (amount <= 0) {
      return Failure(
        'Valor deve ser maior que zero',
        ValidationException.invalidFormat('amount'),
      );
    }

    final piggyBankResult = await getPiggyBank();

      return await piggyBankResult.when(
      success: (piggyBank) async {
        if (piggyBank.saved < amount) {
          return Failure(
            'Saldo insuficiente no cofrinho',
            ValidationException('Saldo insuficiente'),
          );
        }

        final updatedPiggyBank = PiggyBankModel(
          id: piggyBank.id,
          name: piggyBank.name,
          goal: piggyBank.goal,
          saved: piggyBank.saved - amount,
          createdAt: piggyBank.createdAt,
          updatedAt: DateTime.now(),
        );

        final updateResult = await updatePiggyBank(updatedPiggyBank);

        return updateResult.when(
          success: (_) => Success(updatedPiggyBank),
          failure: (error, exception) => Failure(error, exception),
        );
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Update piggy bank goal
  /// Returns Result<PiggyBankModel> with updated piggy bank
  Future<Result<PiggyBankModel>> updateGoal(double newGoal) async {
    if (newGoal <= 0) {
      return Failure(
        'Meta deve ser maior que zero',
        ValidationException.invalidFormat('goal'),
      );
    }

    final piggyBankResult = await getPiggyBank();

      return await piggyBankResult.when(
      success: (piggyBank) async {
        final updatedPiggyBank = PiggyBankModel(
          id: piggyBank.id,
          name: piggyBank.name,
          goal: newGoal,
          saved: piggyBank.saved,
          createdAt: piggyBank.createdAt,
          updatedAt: DateTime.now(),
        );

        final updateResult = await updatePiggyBank(updatedPiggyBank);

        return updateResult.when(
          success: (_) => Success(updatedPiggyBank),
          failure: (error, exception) => Failure(error, exception),
        );
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Reset piggy bank (set current amount to 0)
  /// Returns Result<PiggyBankModel> with reset piggy bank
  Future<Result<PiggyBankModel>> resetPiggyBank() async {
    final piggyBankResult = await getPiggyBank();

      return await piggyBankResult.when(
      success: (piggyBank) async {
        final updatedPiggyBank = PiggyBankModel(
          id: piggyBank.id,
          name: piggyBank.name,
          goal: piggyBank.goal,
          saved: 0.0,
          createdAt: piggyBank.createdAt,
          updatedAt: DateTime.now(),
        );

        final updateResult = await updatePiggyBank(updatedPiggyBank);

        return updateResult.when(
          success: (_) => Success(updatedPiggyBank),
          failure: (error, exception) => Failure(error, exception),
        );
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Stream piggy bank with real-time updates
  /// Returns Stream<PiggyBankModel?> with real-time updates
  Stream<PiggyBankModel?> watchPiggyBank() {
    final uid = _currentUserId;

    if (uid == null) {
      return Stream.value(null);
    }

    return _firestoreService
        .streamDocument(
          collection: _piggyBanksCollection,
          docId: uid,
        )
        .map((doc) {
      if (doc == null || !doc.exists) {
        return null;
      }

      try {
        return PiggyBankModel.fromMap(doc.data() as Map<String, dynamic>);
      } catch (e) {
        return null;
      }
    });
  }

  /// Migrate data from SharedPreferences to Firestore
  /// Returns Result<PiggyBankModel> with migrated data or creates new piggy bank
  Future<Result<PiggyBankModel>> _migrateFromLocalStorage() async {
    final uid = _currentUserId;
    
    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final currentAmount = prefs.getDouble(_localCurrentAmountKey) ?? 0.0;
      final goal = prefs.getDouble(_localGoalKey) ?? 500.0;

      final piggyBank = PiggyBankModel(
        id: uid,
        name: 'Meu Cofrinho',
        goal: goal,
        saved: currentAmount,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      final saveResult = await updatePiggyBank(piggyBank);

      return saveResult.when(
        success: (_) {
          // Clear local storage after successful migration
          prefs.remove(_localCurrentAmountKey);
          prefs.remove(_localGoalKey);
          return Success(piggyBank);
        },
        failure: (error, exception) => Failure(error, exception),
      );
    } catch (e) {
      // If migration fails, create new piggy bank with default values
      final piggyBank = PiggyBankModel(
        id: uid,
        name: 'Meu Cofrinho',
        goal: 500.0,
        saved: 0.0,
        createdAt: DateTime.now(),
      );

      final saveResult = await updatePiggyBank(piggyBank);

      return saveResult.when(
        success: (_) => Success(piggyBank),
        failure: (error, exception) => Failure(error, exception),
      );
    }
  }

  /// Calculate progress percentage
  /// Returns double between 0.0 and 1.0 (or > 1.0 if goal exceeded)
  Future<Result<double>> getProgress() async {
    final piggyBankResult = await getPiggyBank();

    return piggyBankResult.when(
      success: (piggyBank) {
        if (piggyBank.goal == 0) {
          return const Success(0.0);
        }
        final progress = piggyBank.saved / piggyBank.goal;
        return Success(progress);
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Check if goal is reached
  /// Returns Result<bool> indicating if goal is reached
  Future<Result<bool>> isGoalReached() async {
    final progressResult = await getProgress();

    return progressResult.when(
      success: (progress) => Success(progress >= 1.0),
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Get remaining amount to reach goal
  /// Returns Result<double> with remaining amount
  Future<Result<double>> getRemainingAmount() async {
    final piggyBankResult = await getPiggyBank();

    return piggyBankResult.when(
      success: (piggyBank) {
        final remaining = piggyBank.goal - piggyBank.saved;
        return Success(remaining > 0 ? remaining : 0.0);
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Delete piggy bank data
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> deletePiggyBank() async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    return await _firestoreService.deleteDocument(
      collection: _piggyBanksCollection,
      docId: uid,
    );
  }
}
