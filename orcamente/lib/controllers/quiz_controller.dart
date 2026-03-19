import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/quiz.dart';
import '../repositories/user_repository.dart';
import '../services/gemini_service.dart';
import '../services/location_service.dart';
import '../core/result.dart';

class QuizController extends ChangeNotifier {
  final UserRepository _userRepository;
  late final GeminiService _geminiService;
  late final LocationService _locationService;

  int currentStep = 0;
  int totalScore = 0;
  final List<int> selectedOptions = [];
  bool _isLoading = false;
  String? _errorMessage;
  LocationDetails? _userLocation;
  String? _aiProfile;
  String? _aiKnowledgeLevel;
  String? _aiJustification;
  
  List<QuizQuestion> _questions = [];

  QuizController(this._userRepository) {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _geminiService = GeminiService(apiKey: apiKey);
    _locationService = LocationService();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  List<QuizQuestion> get questions => _questions;
  LocationDetails? get userLocation => _userLocation;

  /// Load quiz - use preloaded questions if available, otherwise generate new ones
  Future<Result<void>> loadQuiz({List<QuizQuestion>? preloadedQuestions}) async {
    // If preloaded questions are available, use them
    if (preloadedQuestions != null && preloadedQuestions.isNotEmpty) {
      print('✅ [QuizController] Usando perguntas pré-carregadas (${preloadedQuestions.length} perguntas)');
      _questions = preloadedQuestions;
      _isLoading = false;
      notifyListeners();
      return const Success(null);
    }

    // Otherwise, generate new quiz
    return await generateQuiz();
  }

  /// Generate AI-powered localized quiz questions
  Future<Result<void>> generateQuiz() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('🔄 [QuizController] Gerando novo quiz...');

    // Get user location
    final locationResult = await _locationService.getUserLocation();
    
    return await locationResult.when(
      success: (location) async {
        _userLocation = location.details;
        
        // Generate quiz with AI
        final quizResult = await _geminiService.generateLocalizedQuiz(
          location: location.details,
          topic: 'Educação Financeira',
          questionCount: 5,
        );

        return quizResult.when(
          success: (questions) {
            _questions = questions;
            _isLoading = false;
            notifyListeners();
            return const Success(null);
          },
          failure: (error, exception) {
            _errorMessage = error;
            _isLoading = false;
            notifyListeners();
            return Failure(error, exception);
          },
        );
      },
      failure: (error, exception) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
        return Failure(error, exception);
      },
    );
  }

  /// Avança para a próxima pergunta, acumula pontuação e salva opção selecionada
  void nextStep(int selectedOptionIndex) {
    if (!isFinished) {
      totalScore += questions[currentStep].scores[selectedOptionIndex];
      selectedOptions.add(selectedOptionIndex);
      currentStep++;
      notifyListeners();
    }
  }

  /// Analyze quiz answers using AI to determine profile and knowledge level
  Future<Result<void>> analyzeAnswersWithAI() async {
    if (_userLocation == null) {
      return Failure(
        'Localização do usuário não disponível',
        DataException('missing-location'),
      );
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('🤖 [QuizController] Analisando respostas com IA...');
    
    final result = await _geminiService.analyzeQuizAnswers(
      questions: _questions,
      selectedAnswers: selectedOptions,
      location: _userLocation!,
    );

    return result.when(
      success: (analysis) {
        _aiProfile = analysis['profile'];
        _aiKnowledgeLevel = analysis['knowledgeLevel'];
        _aiJustification = analysis['justification'];
        
        _isLoading = false;
        notifyListeners();
        
        print('✅ [QuizController] Análise completada: $_aiProfile - $_aiKnowledgeLevel');
        return const Success(null);
      },
      failure: (error, exception) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
        
        print('❌ [QuizController] Erro na análise: $error');
        return Failure(error, exception);
      },
    );
  }

  /// Retorna o perfil de comportamento financeiro (usa análise de IA se disponível)
  String getBehaviorProfile() {
    // If AI analysis is available, use it
    if (_aiProfile != null) {
      return _aiProfile!;
    }
    
    // Fallback to score-based profile
    if (totalScore >= 10) return 'Gastador';
    if (totalScore >= 6) return 'Poupador';
    return 'Investidor';
  }

  /// Retorna o nível de conhecimento financeiro (usa análise de IA se disponível)
  String getKnowledgeLevel() {
    // If AI analysis is available, use it
    if (_aiKnowledgeLevel != null) {
      return _aiKnowledgeLevel!;
    }
    
    // Fallback to score-based knowledge level
    if (totalScore >= 10) return 'Iniciante';
    if (totalScore >= 6) return 'Intermediário';
    return 'Avançado';
  }

  /// Retorna a justificativa da análise de IA
  String? getAIJustification() {
    return _aiJustification;
  }

  bool get isLastStep => _questions.isNotEmpty && currentStep == _questions.length - 1;
  bool get isFinished => _questions.isNotEmpty && currentStep >= _questions.length;
  bool get hasQuestions => _questions.isNotEmpty;

  /// Save quiz answers using UserRepository
  Future<Result<void>> saveAnswers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // First, analyze answers with AI
    print('🔍 [QuizController] Iniciando análise de IA antes de salvar...');
    final analysisResult = await analyzeAnswersWithAI();
    
    // Continue even if AI analysis fails (will use fallback scores)
    analysisResult.when(
      success: (_) => print('✅ [QuizController] Análise de IA concluída'),
      failure: (error, _) => print('⚠️ [QuizController] Análise de IA falhou, usando fallback: $error'),
    );

    final quizData = {
      'answers': selectedOptions,
      'totalScore': totalScore,
      'behaviorProfile': getBehaviorProfile(),
      'knowledgeLevel': getKnowledgeLevel(),
      'aiJustification': _aiJustification,
    };

    final result = await _userRepository.saveQuizAnswers(answers: quizData);

    await result.when(
      success: (_) async {
        // Mark quiz as answered in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('quizAnswered', true);

        _isLoading = false;
        notifyListeners();
      },
      failure: (error, exception) async {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Reset quiz to initial state
  void reset() {
    currentStep = 0;
    totalScore = 0;
    selectedOptions.clear();
    _errorMessage = null;
    _aiProfile = null;
    _aiKnowledgeLevel = null;
    _aiJustification = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
