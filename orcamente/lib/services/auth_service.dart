import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orcamente/core/result.dart';
import 'package:orcamente/core/exceptions.dart';

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

  /// Realiza login com email e senha
  /// Returns Result<User> with user data on success or error on failure
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
        return const Failure('Falha ao fazer login. Usuário não encontrado.');
      }

      return Success(credential.user!);
    } on FirebaseAuthException catch (e) {
      final exception = _mapAuthException(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure('Erro inesperado ao fazer login: $e', Exception(e.toString()));
    }
  }

  /// Cria nova conta com email e senha
  /// Also saves additional user data to Firestore
  /// Returns Result<User> with user data on success
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
        return const Failure('Falha ao criar conta. Tente novamente.');
      }

      // Salvar dados adicionais no Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'nome': name,
        'email': email,
        'telefone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Success(credential.user!);
    } on FirebaseAuthException catch (e) {
      final exception = _mapAuthException(e);
      return Failure(exception.message, exception);
    } catch (e) {
      return Failure('Erro ao criar conta: $e', Exception(e.toString()));
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
      return Failure('Erro ao enviar email de recuperação: $e', Exception(e.toString()));
    }
  }

  /// Realiza logout
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao fazer logout: $e', Exception(e.toString()));
    }
  }

  /// Obtém dados do usuário do Firestore
  /// Returns Result<Map<String, dynamic>> with user data
  Future<Result<Map<String, dynamic>>> getUserData() async {
    if (!isAuthenticated()) {
      return const Failure('Usuário não autenticado', AuthException('Usuário não autenticado'));
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (!doc.exists) {
        return const Failure('Dados do usuário não encontrados', DataException('Dados não encontrados'));
      }

      final data = doc.data();
      if (data == null) {
        return const Failure('Dados do usuário vazios', DataException('Dados vazios'));
      }

      return Success(data);
    } catch (e) {
      return Failure('Erro ao buscar dados do usuário: $e', DataException('Erro ao buscar dados'));
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
          'Erro de conexão. Verifique sua internet.',
          code: 'network-request-failed',
        );
      default:
        return AuthException(
          'Erro de autenticação: ${e.message ?? 'Erro desconhecido'}',
          code: e.code,
          originalError: e,
        );
    }
  }
}
