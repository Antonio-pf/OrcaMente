import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz.dart';
import '../repositories/user_repository.dart';
import '../core/result.dart';

class QuizController extends ChangeNotifier {
  final UserRepository _userRepository;

  int currentStep = 0;
  int totalScore = 0;
  final List<int> selectedOptions = [];
  bool _isLoading = false;
  String? _errorMessage;

  QuizController(this._userRepository);

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  final List<QuizQuestion> questions = [
    QuizQuestion(
      id: 'q1',
      question: 'Você costuma gastar tudo o que ganha?',
      options: ['Sim', 'Às vezes', 'Não'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      id: 'q2',
      question: 'Você tem o hábito de guardar parte do seu dinheiro todo mês?',
      options: ['Nunca', 'Às vezes', 'Sempre'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      id: 'q3',
      question: 'Você tem investimentos?',
      options: ['Não', 'Poucos', 'Sim, diversificados'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      id: 'q4',
      question: 'Você entende conceitos como inflação, juros e orçamento?',
      options: ['Não entendo nada', 'Já ouvi falar', 'Sim, entendo bem'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      id: 'q5',
      question: 'Você costuma planejar seus gastos antes de comprar algo?',
      options: ['Nunca', 'Às vezes', 'Sempre'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      id: 'q6',
      question: 'Você já fez algum curso de educação financeira?',
      options: ['Não', 'Sim, básico', 'Sim, avançado'],
      scores: [2, 1, 0],
    ),
  ];

  /// Avança para a próxima pergunta, acumula pontuação e salva opção selecionada
  void nextStep(int selectedOptionIndex) {
    if (!isFinished) {
      totalScore += questions[currentStep].scores[selectedOptionIndex];
      selectedOptions.add(selectedOptionIndex);
      currentStep++;
      notifyListeners();
    }
  }

  /// Retorna o perfil de comportamento financeiro com base na pontuação
  String getBehaviorProfile() {
    if (totalScore >= 10) return 'Gastador';
    if (totalScore >= 6) return 'Poupador';
    return 'Investidor';
  }

  /// Retorna o nível de conhecimento financeiro com base na pontuação
  String getKnowledgeLevel() {
    if (totalScore >= 10) return 'Baixo conhecimento financeiro';
    if (totalScore >= 6) return 'Conhecimento intermediário';
    return 'Bom conhecimento financeiro';
  }

  bool get isLastStep => currentStep == questions.length - 1;
  bool get isFinished => currentStep >= questions.length;

  /// Save quiz answers using UserRepository
  Future<Result<void>> saveAnswers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final quizData = {
      'answers': selectedOptions,
      'totalScore': totalScore,
      'behaviorProfile': getBehaviorProfile(),
      'knowledgeLevel': getKnowledgeLevel(),
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
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
