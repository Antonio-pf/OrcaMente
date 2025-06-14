import 'package:flutter/material.dart';
import 'package:orcamente/controllers/quiz_controller.dart';
import 'package:orcamente/views/quiz/quiz_result.dart';
import '../../../styles/custom_theme.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizController _controller = QuizController();
  final List<int> _selectedOptions = [];

  bool _isSaving = false; // Para evitar múltiplas chamadas

  @override
  Widget build(BuildContext context) {
    if (_controller.isFinished) {
      // Evita chamadas repetidas
      if (!_isSaving) {
        _isSaving = true;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          bool saved = await _controller.saveAnswers();

          if (!mounted) return;

          if (saved) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => QuizResultPage(
                  profile: _controller.getBehaviorProfile(),
                  knowledge: _controller.getKnowledgeLevel(),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Falha ao salvar respostas. Tente novamente.')),
            );

            // Aqui você pode decidir voltar para alguma etapa ou permitir tentar de novo
            setState(() {
              _isSaving = false;
              _controller.currentStep = 0;
              _controller.totalScore = 0;
              _controller.selectedOptions.clear();
            });
          }
        });
      }

      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz de Perfil Financeiro')),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _controller.currentStep,
        onStepTapped: (index) {
          setState(() {
            _controller.currentStep = index;
          });
        },
        controlsBuilder: (context, _) => const SizedBox.shrink(),
        steps: _controller.questions.asMap().entries.map((entry) {
          int index = entry.key;
          var question = entry.value;

          return Step(
            title: Text('Pergunta ${index + 1}'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...List.generate(question.options.length, (i) {
                  return RadioListTile<int>(
                    value: i,
                    groupValue:
                        _selectedOptions.length > index ? _selectedOptions[index] : -1,
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        if (_selectedOptions.length > index) {
                          _selectedOptions[index] = value;
                        } else {
                          _selectedOptions.add(value);
                        }

                        if (!_controller.isFinished) {
                          _controller.nextStep(value);
                        }
                      });
                    },
                    title: Text(question.options[i]),
                  );
                }),
              ],
            ),
            isActive: _controller.currentStep >= index,
          );
        }).toList(),
      ),
    );
  }
}
