import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orcamente/controllers/course_controller.dart';
import 'package:orcamente/models/quiz.dart';
import 'package:orcamente/services/gemini_service.dart';
import 'package:orcamente/services/location_service.dart';
import 'package:orcamente/repositories/course_repository.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/quiz/post_quiz_result_page.dart';
import 'package:get_it/get_it.dart';

class PostQuizPage extends StatefulWidget {
  const PostQuizPage({super.key});

  @override
  State<PostQuizPage> createState() => _PostQuizPageState();
}

class _PostQuizPageState extends State<PostQuizPage> {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final courseController = context.read<CourseController>();
    final gemini = GeminiService(apiKey: dotenv.env['GEMINI_API_KEY'] ?? '');
    final locationService = LocationService();

    final locationResult = await locationService.getUserLocation();
    final location = locationResult.when(
      success: (loc) => loc.details,
      failure: (_, __) => const LocationDetails(
        city: 'São Paulo',
        state: 'SP',
        country: 'Brasil',
        countryCode: 'BR',
      ),
    );

    final result = await gemini.generatePostQuiz(
      studiedTopics: courseController.studiedTopics,
      location: location,
      profile: courseController.course?.profile ?? 'Poupador',
    );

    result.when(
      success: (questions) => setState(() {
        _questions = questions;
        _isLoading = false;
      }),
      failure: (error, _) => setState(() {
        _error = error;
        _isLoading = false;
      }),
    );
  }

  void _answer(int selectedIndex) {
    final score = _questions[_currentIndex].scores[selectedIndex];
    setState(() {
      _score += score;
      _currentIndex++;
    });

    if (_currentIndex >= _questions.length) {
      _finish();
    }
  }

  Future<void> _finish() async {
    final repo = GetIt.instance<CourseRepository>();
    await repo.savePostQuizScore(_score);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PostQuizResultPage(postScore: _score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Final')),
        body: Center(child: Text(_error!)),
      );
    }

    if (_currentIndex >= _questions.length) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Final'),
        backgroundColor: CustomTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_currentIndex + 1} de ${_questions.length}'),
                Text('${(progress * 100).toInt()}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(CustomTheme.primaryColor),
            ),
            const SizedBox(height: 28),
            Text(
              question.question,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.5),
            ),
            const SizedBox(height: 24),
            ...question.options.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _answer(entry.key),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
