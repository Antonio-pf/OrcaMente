import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orcamente/controllers/course_controller.dart';
import 'package:orcamente/models/generated_course.dart';
import 'package:orcamente/styles/custom_theme.dart';

class ModuleContentPage extends StatelessWidget {
  final CourseContentModule module;

  const ModuleContentPage({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CourseController>();
    final isDone =
        controller.course?.completedModuleIds.contains(module.id) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
        backgroundColor: CustomTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        module.estimatedTime,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    module.content,
                    style: const TextStyle(fontSize: 15, height: 1.7),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isDone
                    ? null
                    : () async {
                        await context
                            .read<CourseController>()
                            .markModuleComplete(module.id);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDone ? Colors.grey : CustomTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isDone ? 'Módulo Concluído ✓' : 'Concluir Módulo'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
