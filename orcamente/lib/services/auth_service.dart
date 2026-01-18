import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter para o usuário atual
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  // Stream de mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Realiza login com email e senha
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Tentando fazer login com: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Login bem-sucedido: ${credential.user?.uid}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('❌ Erro FirebaseAuth - Código: ${e.code}, Mensagem: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Erro inesperado no login: $e');
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<User?> createUserWithEmailAndPassword({
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

      if (credential.user != null) {
        // Salvar dados adicionais no Firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'nome': name,
          'email': email,
          'telefone': phone,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Envia email de recuperação de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Realiza logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  /// Verifica se o usuário está autenticado
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  /// Obtém dados do usuário do Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    if (!isAuthenticated()) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      
      return doc.data();
    } catch (e) {
      throw Exception('Erro ao buscar dados do usuário: $e');
    }
  }

  /// Trata exceções do Firebase Auth e retorna mensagens amigáveis
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return 'E-mail ou senha incorretos. Verifique suas credenciais.';
      case 'user-not-found':
        return 'Usuário não encontrado. Verifique o e-mail digitado.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'invalid-email':
        return 'Formato de e-mail inválido.';
      case 'user-disabled':
        return 'A conta foi desativada.';
      case 'email-already-in-use':
        return 'Este e-mail já está sendo usado.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      case 'weak-password':
        return 'Senha muito fraca.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      default:
        return 'Erro de autenticação [${e.code}]: ${e.message}';
    }
  }
}
