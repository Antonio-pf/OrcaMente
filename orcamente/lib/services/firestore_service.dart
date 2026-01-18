import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orcamente/services/auth_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  String? get _userId => _authService.currentUserId;

  /// Verifica se o usuário está autenticado
  void _checkAuth() {
    if (_userId == null) {
      throw Exception('Usuário não autenticado');
    }
  }

  /// Adiciona um documento a uma coleção
  Future<DocumentReference> addDocument({
    required String collection,
    required Map<String, dynamic> data,
    bool requireAuth = true,
  }) async {
    if (requireAuth) _checkAuth();
    
    return await _firestore.collection(collection).add(data);
  }

  /// Adiciona um documento com ID específico
  Future<void> setDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .set(data, SetOptions(merge: merge));
  }

  /// Obtém um documento
  Future<DocumentSnapshot> getDocument({
    required String collection,
    required String documentId,
  }) async {
    return await _firestore
        .collection(collection)
        .doc(documentId)
        .get();
  }

  /// Atualiza um documento
  Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .update(data);
  }

  /// Deleta um documento
  Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    await _firestore
        .collection(collection)
        .doc(documentId)
        .delete();
  }

  /// Busca documentos com query
  Future<QuerySnapshot> getDocuments({
    required String collection,
    Query Function(CollectionReference)? queryBuilder,
  }) async {
    CollectionReference collectionRef = _firestore.collection(collection);
    
    if (queryBuilder != null) {
      return await queryBuilder(collectionRef).get();
    }
    
    return await collectionRef.get();
  }

  /// Stream de documentos
  Stream<QuerySnapshot> streamDocuments({
    required String collection,
    Query Function(CollectionReference)? queryBuilder,
  }) {
    CollectionReference collectionRef = _firestore.collection(collection);
    
    if (queryBuilder != null) {
      return queryBuilder(collectionRef).snapshots();
    }
    
    return collectionRef.snapshots();
  }

  /// Subcoleção do usuário - Adiciona documento
  Future<DocumentReference> addToUserSubcollection({
    required String subcollection,
    required Map<String, dynamic> data,
  }) async {
    _checkAuth();
    
    return await _firestore
        .collection('users')
        .doc(_userId)
        .collection(subcollection)
        .add(data);
  }

  /// Subcoleção do usuário - Busca documentos
  Future<QuerySnapshot> getUserSubcollectionDocuments({
    required String subcollection,
    Query Function(CollectionReference)? queryBuilder,
  }) async {
    _checkAuth();
    
    CollectionReference collectionRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection(subcollection);
    
    if (queryBuilder != null) {
      return await queryBuilder(collectionRef).get();
    }
    
    return await collectionRef.get();
  }

  /// Subcoleção do usuário - Stream de documentos
  Stream<QuerySnapshot> streamUserSubcollection({
    required String subcollection,
    Query Function(CollectionReference)? queryBuilder,
  }) {
    if (_userId == null) {
      return Stream.empty();
    }
    
    CollectionReference collectionRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection(subcollection);
    
    if (queryBuilder != null) {
      return queryBuilder(collectionRef).snapshots();
    }
    
    return collectionRef.snapshots();
  }

  /// Subcoleção do usuário - Deleta documento
  Future<void> deleteFromUserSubcollection({
    required String subcollection,
    required String documentId,
  }) async {
    _checkAuth();
    
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection(subcollection)
        .doc(documentId)
        .delete();
  }

  /// Batch write para múltiplas operações
  Future<void> batchWrite(
    void Function(WriteBatch batch) operations,
  ) async {
    WriteBatch batch = _firestore.batch();
    operations(batch);
    await batch.commit();
  }

  /// Transaction para operações atômicas
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) async {
    return await _firestore.runTransaction(updateFunction);
  }
}
