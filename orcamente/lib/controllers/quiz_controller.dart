import 'package:orcamente/models/quiz.dart';

class QuizController {
  int currentStep = 0;
  int totalScore = 0;

  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'Você costuma gastar tudo o que ganha?',
      options: ['Sim', 'Às vezes', 'Não'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      question: 'Você tem o hábito de guardar parte do seu dinheiro todo mês?',
      options: ['Nunca', 'Às vezes', 'Sempre'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      question: 'Você tem investimentos?',
      options: ['Não', 'Poucos', 'Sim, diversificados'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      question: 'Você entende conceitos como inflação, juros e orçamento?',
      options: ['Não entendo nada', 'Já ouvi falar', 'Sim, entendo bem'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      question: 'Você costuma planejar seus gastos antes de comprar algo?',
      options: ['Nunca', 'Às vezes', 'Sempre'],
      scores: [2, 1, 0],
    ),
    QuizQuestion(
      question: 'Você já fez algum curso de educação financeira?',
      options: ['Não', 'Sim, básico', 'Sim, avançado'],
      scores: [2, 1, 0],
    ),
  ];

  void nextStep(int selectedOptionIndex) {
    totalScore += questions[currentStep].scores[selectedOptionIndex];
    currentStep++;
  }

  String getBehaviorProfile() {
    if (totalScore >= 10) return 'Gastador';
    if (totalScore >= 6) return 'Poupador';
    return 'Investidor';
  }

  String getKnowledgeLevel() {
    if (totalScore >= 10) return 'Baixo conhecimento financeiro';
    if (totalScore >= 6) return 'Conhecimento intermediário';
    return 'Bom conhecimento financeiro';
  }

  bool get isLastStep => currentStep == questions.length - 1;
  bool get isFinished => currentStep >= questions.length;
}
