import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_course_card.dart';
import 'package:orcamente/models/course.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/course_modules_pages.dart';


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
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 4,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final icon = getCourseIcon(course.title);

                  return CustomCourseCard(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
