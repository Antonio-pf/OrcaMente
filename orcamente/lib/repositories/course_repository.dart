import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orcamente/core/result.dart';
import 'package:orcamente/core/exceptions.dart';
import 'package:orcamente/models/generated_course.dart';
import 'package:orcamente/services/firestore_service.dart';
import 'package:orcamente/services/auth_service.dart';

/// Repository for generated course data operations.
/// Handles CRUD operations for the user's personalised course in Firestore.
class CourseRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  static const String _collection = 'generated_courses';

  CourseRepository({
    FirestoreService? firestoreService,
    AuthService? authService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _authService = authService ?? AuthService();

  String? get _uid => _authService.currentUserId;

  /// Fetch the current user's generated course.
  /// Returns [Success(null)] if no document exists yet (new user).
  Future<Result<GeneratedCourse?>> getCourse() async {
    final uid = _uid;
    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('not-authenticated'),
      );
    }

    final result = await _firestoreService.getDocumentData(
      collection: _collection,
      docId: uid,
    );

    return result.when(
      success: (data) => Success(GeneratedCourse.fromMap(data)),
      failure: (error, exception) {
        if (exception is DataException && exception.code == 'not-found') {
          return const Success(null);
        }
        return Failure(error, exception);
      },
    );
  }

  /// Persist (create or overwrite) the generated course for the current user.
  Future<Result<void>> saveCourse(GeneratedCourse course) async {
    final uid = _uid;
    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('not-authenticated'),
      );
    }
    return _firestoreService.setDocument(
      collection: _collection,
      docId: uid,
      data: course.toMap(),
    );
  }

  /// Atomically append [moduleId] to the completedModuleIds array field.
  /// Uses [FieldValue.arrayUnion] so duplicate IDs are never added.
  Future<Result<void>> markModuleComplete(String moduleId) async {
    final uid = _uid;
    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('not-authenticated'),
      );
    }
    return _firestoreService.updateDocument(
      collection: _collection,
      docId: uid,
      data: {
        'completedModuleIds': FieldValue.arrayUnion([moduleId]),
      },
    );
  }

  /// Persist the post-quiz score for the current user.
  Future<Result<void>> savePostQuizScore(int score) async {
    final uid = _uid;
    if (uid == null) {
      return Failure(
        'Usuário não autenticado',
        AuthException('not-authenticated'),
      );
    }
    return _firestoreService.updateDocument(
      collection: _collection,
      docId: uid,
      data: {
        'postQuizScore': score,
        'postQuizCompletedAt': DateTime.now().toIso8601String(),
      },
    );
  }
}
