import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_course_card.dart';
import 'package:orcamente/models/course.dart';
import 'package:orcamente/styles/custom_theme.dart';

class CourseModulesPage extends StatelessWidget {
  final Course course;

  const CourseModulesPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final modules = course.modules;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: CustomTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 16,
            childAspectRatio: 4,
          ),
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final module = modules[index];
            return CustomCourseCard(
              title: module.title,
              icon: Icons.menu_book,
              onTap: () {
               // ScaffoldMessenger.of(context).showSnackBar(
                 // SnackBar(content: Text('Abrindo módulo: ${module.title}')),
                //);
              },
            );
          },
        ),
      ),
    );
  }
}
