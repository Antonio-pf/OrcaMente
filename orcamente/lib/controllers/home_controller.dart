import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../repositories/user_repository.dart';
import '../services/gemini_service.dart';
import '../services/location_service.dart';
import '../models/quiz.dart';
import '../core/result.dart';

class HomeController extends ChangeNotifier {
  final UserRepository _userRepository;
  late final GeminiService _geminiService;
  late final LocationService _locationService;

  String _appBarTitle = 'Olá';
  String _userName = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _titleChanged = false;
  
  // Quiz pre-loading
  List<QuizQuestion>? _preloadedQuestions;
  bool _isLoadingQuiz = false;

  HomeController(this._userRepository) {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _geminiService = GeminiService(apiKey: apiKey);
    _locationService = LocationService();
    _initialize();
  }

  // Getters
  List<QuizQuestion>? get preloadedQuestions => _preloadedQuestions;
  bool get isLoadingQuiz => _isLoadingQuiz;

  // Getters
  String get appBarTitle => _appBarTitle;
  String get userName => _userName;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Initialize controller by loading user data and pre-loading quiz
  Future<void> _initialize() async {
    await loadUserData();
    initTitleChange();
    
    // Pre-load quiz in background
    _preloadQuizInBackground();
  }

  /// Pre-load quiz questions in background for better UX
  Future<void> _preloadQuizInBackground() async {
    print('🎯 [HomeController] Iniciando pré-carregamento do quiz em background...');
    _isLoadingQuiz = true;
    
    try {
      // Get user location
      final locationResult = await _locationService.getUserLocation();
      
      await locationResult.when(
        success: (location) async {
          print('🎯 [HomeController] Localização obtida: ${location.details.city}');
          
          // Generate quiz with AI
          final quizResult = await _geminiService.generateLocalizedQuiz(
            location: location.details,
            topic: 'Educação Financeira',
            questionCount: 5,
          );

          quizResult.when(
            success: (questions) {
              _preloadedQuestions = questions;
              _isLoadingQuiz = false;
              print('✅ [HomeController] Quiz pré-carregado com ${questions.length} perguntas!');
              notifyListeners();
            },
            failure: (error, exception) {
              _isLoadingQuiz = false;
              print('⚠️ [HomeController] Falha ao pré-carregar quiz: $error');
              notifyListeners();
            },
          );
        },
        failure: (error, exception) {
          _isLoadingQuiz = false;
          print('⚠️ [HomeController] Falha ao obter localização para quiz: $error');
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoadingQuiz = false;
      print('❌ [HomeController] Erro ao pré-carregar quiz: $e');
      notifyListeners();
    }
  }

  /// Load user data from repository
  Future<Result<void>> loadUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _userRepository.getUserData();

    result.when(
      success: (userData) {
        _userName = userData['nome'] ?? '';
        if (_userName.isNotEmpty) {
          _appBarTitle = 'Olá, $_userName';
        } else {
          _appBarTitle = 'Olá';
        }
        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) {
        _errorMessage = error;
        _appBarTitle = 'Olá';
        _isLoading = false;
        notifyListeners();
      },
    );

    return result.map((_) => null);
  }

  /// Animate title change from greeting to app name
  void initTitleChange() {
    if (_titleChanged) return;

    Future.delayed(const Duration(seconds: 4), () {
      _appBarTitle = 'OrçaMente';
      _titleChanged = true;
      notifyListeners();
    });
  }

  /// Reload user data
  Future<Result<void>> refresh() async {
    _titleChanged = false;
    return await loadUserData();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
