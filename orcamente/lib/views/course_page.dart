import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_course_card.dart';
import 'package:orcamente/models/course.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/course_modules_pages.dart';
import 'package:orcamente/views/game/game_page.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  IconData getCourseIcon(String title) {
    if (title == 'Finanças na Prática') {
      return Icons.edit_note;
    } else {
      return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses = Course.sampleCourses;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Escolha o que deseja desbravar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Conteúdo scrollável
            Expanded(
              child: ListView(
                children: [
                  // Cursos
                  ...courses.map((course) {
                    final icon = getCourseIcon(course.title);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CustomCourseCard(
                        title: course.title,
                        icon: icon,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseModulesPage(course: course),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),

                  CustomCourseCard(
                    title: 'Aprenda Jogando',
                    icon: Icons.videogame_asset,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EndlessRunnerGame(),
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
