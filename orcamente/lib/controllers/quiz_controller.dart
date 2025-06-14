import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orcamente/models/quiz.dart';

class QuizController {
  int currentStep = 0;
  int totalScore = 0;
  final List<int> selectedOptions = [];

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

  /// Avança para a próxima pergunta, acumula pontuação e salva opção selecionada
  void nextStep(int selectedOptionIndex) {
    if (!isFinished) {
      totalScore += questions[currentStep].scores[selectedOptionIndex];
      selectedOptions.add(selectedOptionIndex);
      currentStep++;
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

  Future<bool> saveAnswers() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final dataToSave = {
        'userId': user.uid,
        'answers': selectedOptions,
        'totalScore': totalScore,
        'behaviorProfile': getBehaviorProfile(),
        'knowledgeLevel': getKnowledgeLevel(),
        'answeredAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('quiz_answers')
          .doc(user.uid)
          .set(dataToSave);

      return true;
    } catch (e) {
      print('[ERRO] Falha ao salvar quiz: $e');
      return false;
    }
  }
}
