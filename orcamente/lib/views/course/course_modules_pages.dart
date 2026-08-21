import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orcamente/controllers/course_controller.dart';
import 'package:orcamente/models/generated_course.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/course/module_content_page.dart';

class CourseModulesPage extends StatelessWidget {
  final CourseTopic topic;

  const CourseModulesPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CourseController>();
    final completedIds = controller.course?.completedModuleIds ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        backgroundColor: CustomTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topic.modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final module = topic.modules[index];
          final isDone = completedIds.contains(module.id);

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: isDone
                    ? CustomTheme.primaryColor
                    : Colors.grey.shade200,
                child: Icon(
                  isDone ? Icons.check : Icons.menu_book,
                  color: isDone ? Colors.white : Colors.grey,
                ),
              ),
              title: Text(
                module.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? Colors.grey : null,
                ),
              ),
              subtitle: Text(module.estimatedTime),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModuleContentPage(module: module),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
