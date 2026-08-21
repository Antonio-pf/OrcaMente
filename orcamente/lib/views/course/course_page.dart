import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orcamente/controllers/course_controller.dart';
import 'package:orcamente/models/generated_course.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/course/course_modules_pages.dart';
import 'package:orcamente/views/quiz/post_quiz_page.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CourseController>();

    if (controller.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.course == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Complete o quiz para gerar sua trilha personalizada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final course = controller.course!;
    final completedCount = course.completedModuleIds.length;
    final totalCount = course.totalModules;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Sua Trilha Personalizada',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.primaryColor,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '${course.city}, ${course.state} · Perfil: ${course.profile}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$completedCount de $totalCount módulos'),
                Text(
                  '${(course.progressPercent * 100).toInt()}%',
                  style: TextStyle(
                    color: CustomTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: course.progressPercent,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(CustomTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: course.topics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final topic = course.topics[index];
                  return _TopicCard(
                    topic: topic,
                    completedModuleIds: course.completedModuleIds,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseModulesPage(topic: topic),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (course.isFullyCompleted) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PostQuizPage()),
                  ),
                  icon: const Icon(Icons.quiz),
                  label: const Text('Fazer Quiz Final'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final CourseTopic topic;
  final List<String> completedModuleIds;
  final VoidCallback onTap;

  const _TopicCard({
    required this.topic,
    required this.completedModuleIds,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completedInTopic =
        topic.modules.where((m) => completedModuleIds.contains(m.id)).length;
    final totalInTopic = topic.modules.length;
    final topicProgress =
        totalInTopic == 0 ? 0.0 : completedInTopic / totalInTopic;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      topic.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    '$completedInTopic/$totalInTopic',
                    style: TextStyle(
                      color: CustomTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: topicProgress,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      AlwaysStoppedAnimation(CustomTheme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
