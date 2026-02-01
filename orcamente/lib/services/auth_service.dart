import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orcamente/core/result.dart';
import 'package:orcamente/core/exceptions.dart';
import 'package:orcamente/core/constants.dart';
import 'package:orcamente/core/messages.dart';

/// Service for Firebase Authentication operations
/// Returns Result<T> for type-safe error handling
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter para o usuário atual
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  // Stream de mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Verifica se o usuário está autenticado
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<Result<User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return const Failure(AppMessages.authUserNotFound);
      }

      return Success(credential.user!);
    } on FirebaseAuthException catch (e) {
      final exception = _mapAuthException(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure(
        'Erro inesperado ao fazer login: $e',
        Exception(e.toString()),
      );
    }
  }

  Future<Result<User>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return const Failure(AppMessages.authUnknownError);
      }

      // Salvar dados adicionais no Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .set({
            AppConstants.fieldUserName: name,
            AppConstants.fieldUserEmail: email,
            AppConstants.fieldUserPhone: phone,
            AppConstants.fieldCreatedAt: FieldValue.serverTimestamp(),
          });

      return Success(credential.user!);
    } on FirebaseAuthException catch (e) {
      final exception = _mapAuthException(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure(
        '${AppMessages.authUnknownError}: $e',
        Exception(e.toString()),
      );
    }
  }

  /// Envia email de recuperação de senha
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Success(null);
    } on FirebaseAuthException catch (e) {
      final exception = _mapAuthException(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure(
        '${AppMessages.authUnknownError}: $e',
        Exception(e.toString()),
      );
    }
  }

  /// Realiza logout
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Success(null);
    } catch (e) {
      return Failure(
        '${AppMessages.authUnknownError}: $e',
        Exception(e.toString()),
      );
    }
  }

  /// Obtém dados do usuário do Firestore
  /// Returns Result<Map<String, dynamic>> with user data
  Future<Result<Map<String, dynamic>>> getUserData() async {
    if (!isAuthenticated()) {
      return Failure(
        AppMessages.authUnknownError,
        AuthException(AppMessages.authUnknownError),
      );
    }

    try {
      final doc =
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(_auth.currentUser!.uid)
              .get();

      if (!doc.exists) {
        return Failure(
          AppMessages.userLoadError,
          DataException(AppMessages.firestoreNotFound),
        );
      }

      final data = doc.data();
      if (data == null) {
        return Failure(
          AppMessages.userLoadError,
          DataException(AppMessages.firestoreNotFound),
        );
      }

      return Success(data);
    } catch (e) {
      return Failure(
        '${AppMessages.userLoadError}: $e',
        DataException(AppMessages.userLoadError),
      );
    }
  }

  /// Maps FirebaseAuthException to custom AuthException
  AuthException _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
        return AuthException.invalidCredentials();
      case 'user-not-found':
        return AuthException.userNotFound();
      case 'invalid-email':
        return AuthException.invalidEmail();
      case 'user-disabled':
        return AuthException.userDisabled();
      case 'email-already-in-use':
        return AuthException.emailAlreadyInUse();
      case 'operation-not-allowed':
        return AuthException.operationNotAllowed();
      case 'weak-password':
        return AuthException.weakPassword();
      case 'too-many-requests':
        return AuthException.tooManyRequests();
      case 'network-request-failed':
        return const AuthException(
          AppMessages.networkNoConnection,
          code: AppConstants.errorCodeNetworkRequestFailed,
        );
      default:
        return AuthException(
          AppMessages.getAuthErrorMessage(e.code),
          code: e.code,
          originalError: e,
        );
    }
  }
}
