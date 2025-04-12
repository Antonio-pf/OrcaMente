import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_course_card.dart';
import 'package:orcamente/models/course.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/course/course_modules_pages.dart';
import 'package:orcamente/views/game/game_page.dart';
import 'package:orcamente/components/widgets/shimmer_list.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  bool _isLoading = true;
  late List<Course> courses;

  @override
  void initState() {
    super.initState();
    // Simula carregamento
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        courses = Course.sampleCourses;
        _isLoading = false;
      });
    });
  }

  IconData getCourseIcon(String title) {
    if (title == 'Finanças na Prática') {
      return Icons.edit_note;
    } else {
      return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Escolha o que deseja aprofundar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green
                ),
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: _isLoading
                  ? const ShimmerPlaceholderList(itemCount: 3, itemHeight: 100)
                  : ListView(
                      children: [
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
                                    builder: (context) => CourseModulesPage(course: course),
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
                              ),
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
