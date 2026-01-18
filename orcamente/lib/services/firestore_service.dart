import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orcamente/core/result.dart';
import 'package:orcamente/core/exceptions.dart';

/// Generic Firestore service for CRUD operations
/// Returns Result<T> for type-safe error handling
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get a document from Firestore
  /// Returns Result<DocumentSnapshot> with document data
  Future<Result<DocumentSnapshot>> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();

      if (!doc.exists) {
        return Failure(
          'Documento não encontrado',
          DataException.notFound(),
        );
      }

      return Success(doc);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao buscar documento: $e',
        DataException('Erro ao buscar documento'),
      );
    }
  }

  /// Get document data as Map
  /// Returns Result<Map<String, dynamic>> with document data
  Future<Result<Map<String, dynamic>>> getDocumentData({
    required String collection,
    required String docId,
  }) async {
    final result = await getDocument(collection: collection, docId: docId);

    return result.when(
      success: (doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          return Failure(
            'Documento vazio',
            DataException.invalidFormat(),
          );
        }
        return Success(data);
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }

  /// Set (create or overwrite) a document in Firestore
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).set(
            data,
            SetOptions(merge: merge),
          );

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao salvar documento: $e',
        DataException.saveFailed(),
      );
    }
  }

  /// Update an existing document in Firestore
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao atualizar documento: $e',
        DataException.saveFailed(),
      );
    }
  }

  /// Delete a document from Firestore
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao deletar documento: $e',
        DataException.deleteFailed(),
      );
    }
  }

  /// Add a document to a collection (auto-generated ID)
  /// Returns Result<String> with the generated document ID
  Future<Result<String>> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore.collection(collection).add(data);

      return Success(docRef.id);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao adicionar documento: $e',
        DataException.saveFailed(),
      );
    }
  }

  /// Get all documents from a collection
  /// Returns Result<List<QueryDocumentSnapshot>> with documents
  Future<Result<List<QueryDocumentSnapshot>>> getCollection({
    required String collection,
    Query Function(CollectionReference)? queryBuilder,
  }) async {
    try {
      CollectionReference collectionRef = _firestore.collection(collection);
      Query query = queryBuilder?.call(collectionRef) ?? collectionRef;

      final querySnapshot = await query.get();

      return Success(querySnapshot.docs);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao buscar coleção: $e',
        DataException.loadFailed(),
      );
    }
  }

  /// Stream documents from a collection
  /// Returns Stream<List<QueryDocumentSnapshot>> with real-time updates
  Stream<List<QueryDocumentSnapshot>> streamCollection({
    required String collection,
    Query Function(CollectionReference)? queryBuilder,
  }) {
    try {
      CollectionReference collectionRef = _firestore.collection(collection);
      Query query = queryBuilder?.call(collectionRef) ?? collectionRef;

      return query.snapshots().map((snapshot) => snapshot.docs);
    } catch (e) {
      // Return empty stream on error
      return Stream.value([]);
    }
  }

  /// Stream a single document
  /// Returns Stream<DocumentSnapshot?> with real-time updates
  Stream<DocumentSnapshot?> streamDocument({
    required String collection,
    required String docId,
  }) {
    try {
      return _firestore
          .collection(collection)
          .doc(docId)
          .snapshots()
          .map((snapshot) => snapshot.exists ? snapshot : null);
    } catch (e) {
      return Stream.value(null);
    }
  }

  /// Add document to subcollection
  /// Returns Result<String> with generated document ID
  Future<Result<String>> addToSubcollection({
    required String collection,
    required String docId,
    required String subcollection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore
          .collection(collection)
          .doc(docId)
          .collection(subcollection)
          .add(data);

      return Success(docRef.id);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao adicionar à subcoleção: $e',
        DataException.saveFailed(),
      );
    }
  }

  /// Get documents from subcollection
  /// Returns Result<List<QueryDocumentSnapshot>> with documents
  Future<Result<List<QueryDocumentSnapshot>>> getSubcollection({
    required String collection,
    required String docId,
    required String subcollection,
    Query Function(CollectionReference)? queryBuilder,
  }) async {
    try {
      CollectionReference collectionRef = _firestore
          .collection(collection)
          .doc(docId)
          .collection(subcollection);

      Query query = queryBuilder?.call(collectionRef) ?? collectionRef;

      final querySnapshot = await query.get();

      return Success(querySnapshot.docs);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao buscar subcoleção: $e',
        DataException.loadFailed(),
      );
    }
  }

  /// Stream subcollection with real-time updates
  Stream<List<QueryDocumentSnapshot>> streamSubcollection({
    required String collection,
    required String docId,
    required String subcollection,
    Query Function(CollectionReference)? queryBuilder,
  }) {
    try {
      CollectionReference collectionRef = _firestore
          .collection(collection)
          .doc(docId)
          .collection(subcollection);

      Query query = queryBuilder?.call(collectionRef) ?? collectionRef;

      return query.snapshots().map((snapshot) => snapshot.docs);
    } catch (e) {
      return Stream.value([]);
    }
  }

  /// Delete document from subcollection
  /// Returns Result<void> indicating success or failure
  Future<Result<void>> deleteFromSubcollection({
    required String collection,
    required String docId,
    required String subcollection,
    required String subdocId,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId)
          .collection(subcollection)
          .doc(subdocId)
          .delete();

      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        _mapFirestoreError(e),
        _mapFirestoreException(e),
      );
    } catch (e) {
      return Failure(
        'Erro ao deletar da subcoleção: $e',
        DataException.deleteFailed(),
      );
    }
  }

  /// Maps FirebaseException to user-friendly error message
  String _mapFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Você não tem permissão para acessar estes dados.';
      case 'not-found':
        return 'Dados não encontrados.';
      case 'already-exists':
        return 'Dados já existem.';
      case 'resource-exhausted':
        return 'Limite de recursos excedido. Tente novamente mais tarde.';
      case 'unauthenticated':
        return 'Você precisa estar autenticado para realizar esta ação.';
      case 'unavailable':
        return 'Serviço temporariamente indisponível. Tente novamente.';
      case 'deadline-exceeded':
        return 'Operação expirou. Tente novamente.';
      default:
        return 'Erro ao acessar dados [${e.code}]: ${e.message ?? 'Erro desconhecido'}';
    }
  }

  /// Maps FirebaseException to DataException
  DataException _mapFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return DataException.permissionDenied();
      case 'not-found':
        return DataException.notFound();
      case 'already-exists':
        return DataException.alreadyExists();
      default:
        return DataException(
          _mapFirestoreError(e),
          code: e.code,
          originalError: e,
        );
    }
  }
}
