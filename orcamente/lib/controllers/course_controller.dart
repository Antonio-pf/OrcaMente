import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/generated_course.dart';
import '../repositories/course_repository.dart';
import '../services/gemini_service.dart';
import '../services/location_service.dart';
import '../core/result.dart';

class CourseController extends ChangeNotifier {
  final CourseRepository _courseRepository;
  late final GeminiService _geminiService;

  GeneratedCourse? _course;
  bool _isLoading = false;
  String? _errorMessage;

  CourseController(this._courseRepository) {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _geminiService = GeminiService(apiKey: apiKey);
  }

  GeneratedCourse? get course => _course;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  List<String> get studiedTopics =>
      _course?.topics.map((t) => t.title).toList() ?? [];

  Future<Result<void>> loadOrGenerateCourse({
    required LocationDetails location,
    required String profile,
    required String knowledgeLevel,
    required List<String> weakTopics,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final existing = await _courseRepository.getCourse();

    final result = await existing.when(
      success: (course) async {
        if (course != null) {
          _course = course;
          _isLoading = false;
          notifyListeners();
          return const Success<void>(null);
        }
        return await _generateAndSave(
          location: location,
          profile: profile,
          knowledgeLevel: knowledgeLevel,
          weakTopics: weakTopics,
        );
      },
      failure: (error, exception) async {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
        return Failure<void>(error, exception);
      },
    );

    return result;
  }

  Future<Result<void>> _generateAndSave({
    required LocationDetails location,
    required String profile,
    required String knowledgeLevel,
    required List<String> weakTopics,
  }) async {
    final quizResults = {
      'behaviorProfile': profile,
      'knowledgeLevel': knowledgeLevel,
    };

    final generated = await _geminiService.generatePersonalizedContent(
      quizResults: quizResults,
      location: location,
      weakTopics:
          weakTopics.isEmpty ? ['educação financeira básica'] : weakTopics,
    );

    return await generated.when(
      success: (data) async {
        final learningPath = data['learningPath'] as List<dynamic>? ?? [];
        final practicalTips =
            (data['practicalTips'] as List<dynamic>? ?? [])
                .map((e) => e.toString())
                .toList();

        final topics = learningPath.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value as Map<String, dynamic>;
          final modules =
              (t['modules'] as List<dynamic>? ?? []).asMap().entries.map((me) {
                final mi = me.key;
                final m = me.value as Map<String, dynamic>;
                return CourseContentModule(
                  id: 't${i}_m$mi',
                  title: m['title'] as String? ?? '',
                  content: m['content'] as String? ?? '',
                  estimatedTime: m['estimatedTime'] as String? ?? '10 min',
                );
              }).toList();

          return CourseTopic(
            id: 't$i',
            title: t['topic'] as String? ?? '',
            description: t['description'] as String? ?? '',
            modules: modules,
          );
        }).toList();

        final course = GeneratedCourse(
          profile: profile,
          city: location.city,
          state: location.state,
          topics: topics,
          practicalTips: practicalTips,
          completedModuleIds: [],
          generatedAt: DateTime.now(),
        );

        final saved = await _courseRepository.saveCourse(course);
        return await saved.when(
          success: (_) async {
            _course = course;
            _isLoading = false;
            notifyListeners();
            return const Success<void>(null);
          },
          failure: (error, exception) async {
            _errorMessage = error;
            _isLoading = false;
            notifyListeners();
            return Failure<void>(error, exception);
          },
        );
      },
      failure: (error, exception) async {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
        return Failure<void>(error, exception);
      },
    );
  }

  Future<void> markModuleComplete(String moduleId) async {
    if (_course == null) return;
    if (_course!.completedModuleIds.contains(moduleId)) return;

    final result = await _courseRepository.markModuleComplete(moduleId);
    result.when(
      success: (_) {
        _course = _course!.copyWith(
          completedModuleIds: [..._course!.completedModuleIds, moduleId],
        );
        notifyListeners();
      },
      failure: (error, _) {
        _errorMessage = error;
        notifyListeners();
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
