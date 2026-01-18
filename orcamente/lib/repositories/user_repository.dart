import 'package:orcamente/core/result.dart';
import 'package:orcamente/core/exceptions.dart';
import 'package:orcamente/services/firestore_service.dart';
import 'package:orcamente/services/auth_service.dart';

/// Repository for user data operations
/// Handles user profile data and quiz results
class UserRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  UserRepository({
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _authService = authService ?? AuthService();

  static const String _usersCollection = 'users';
  static const String _quizAnswersCollection = 'quiz_answers';

  /// Get current user ID or return error
  String? get _currentUserId => _authService.currentUserId;

  /// Get user data from Firestore
  /// Returns Result<Map<String, dynamic>> with user data
  Future<Result<Map<String, dynamic>>> getUserData([String? userId]) async {
    final uid = userId ?? _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    return await _firestoreService.getDocumentData(
      collection: _usersCollection,
      docId: uid,
    );
  }

  /// Create user data in Firestore
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> createUser({
    required String userId,
    required String name,
    required String email,
    required String phone,
  }) async {
    final userData = {
      'nome': name,
      'email': email,
      'telefone': phone,
      'createdAt': DateTime.now().toIso8601String(),
    };

    return await _firestoreService.setDocument(
      collection: _usersCollection,
      docId: userId,
      data: userData,
    );
  }

  /// Update user data in Firestore
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> updateUserData({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    return await _firestoreService.updateDocument(
      collection: _usersCollection,
      docId: userId,
      data: data,
    );
  }

  /// Update current user's data
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> updateCurrentUserData(
    Map<String, dynamic> data,
  ) async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    return await updateUserData(userId: uid, data: data);
  }

  /// Save quiz answers for user
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> saveQuizAnswers({
    required Map<String, dynamic> answers,
  }) async {
    final uid = _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    final quizData = {
      'userId': uid,
      'answers': answers,
      'completedAt': DateTime.now().toIso8601String(),
    };

    return await _firestoreService.setDocument(
      collection: _quizAnswersCollection,
      docId: uid,
      data: quizData,
    );
  }

  /// Get quiz answers for user
  /// Returns Result<Map<String, dynamic>> with quiz answers
  Future<Result<Map<String, dynamic>>> getQuizAnswers([String? userId]) async {
    final uid = userId ?? _currentUserId;

    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('Usuário não autenticado'),
      );
    }

    return await _firestoreService.getDocumentData(
      collection: _quizAnswersCollection,
      docId: uid,
    );
  }

  /// Check if user has completed quiz
  /// Returns Result<bool> indicating if quiz was completed
  Future<Result<bool>> hasCompletedQuiz([String? userId]) async {
    final result = await getQuizAnswers(userId);

    return result.when(
      success: (data) => const Success(true),
      failure: (error, exception) {
        // If document not found, quiz was not completed
        if (exception is DataException && exception.code == 'not-found') {
          return const Success(false);
        }
        // Other errors propagate
        return Failure(error, exception);
      },
    );
  }

  /// Delete user data (for account deletion)
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> deleteUserData(String userId) async {
    // Delete user document
    final userResult = await _firestoreService.deleteDocument(
      collection: _usersCollection,
      docId: userId,
    );

    if (userResult.isFailure) {
      return userResult;
    }

    // Delete quiz answers if exists
    await _firestoreService.deleteDocument(
      collection: _quizAnswersCollection,
      docId: userId,
    );

    return const Success(null);
  }
}
