import 'package:orcamente/models/course_module.dart';

class Course {
  final String title;
  final String description;
  final List<CourseModule> modules;

  Course({
    required this.title,
    required this.description,
    required this.modules,
  });

  static List<Course> get sampleCourses => [
    Course(
      title: 'Finanças na Prática',
      description:
          'Aprenda a organizar seu orçamento e controlar seus gastos no dia a dia.',
      modules: [
        CourseModule(
          title: 'Orçamento Pessoal',
          description: 'Aprenda a fazer e acompanhar seu orçamento.',
        ),
        CourseModule(
          title: 'Controle de Gastos',
          description: 'Dicas práticas para não gastar além do necessário.',
        ),
        CourseModule(
          title: 'Reserva de Emergência',
          description: 'Por que e como montar uma reserva financeira.',
        ),
        CourseModule(
          title: 'Planejamento Financeiro Mensal',
          description: 'Organize seu mês de forma estratégica.',
        ),
        CourseModule(
          title: 'Metas Financeiras',
          description: 'Como definir e alcançar metas realistas.',
        ),
      ],
    ),
    Course(
      title: 'Educação Financeira e Economia',
      description:
          'Entenda conceitos econômicos e como aplicar a educação financeira no cotidiano.',
      modules: [
        CourseModule(
          title: 'O que é Educação Financeira',
          description: 'Conceitos básicos de finanças pessoais.',
        ),
        CourseModule(
          title: 'Inflação e Poder de Compra',
          description: 'Como a inflação impacta seu dinheiro.',
        ),
        CourseModule(
          title: 'Renda Fixa e Renda Variável',
          description: 'Tipos de investimento e seus riscos.',
        ),
        CourseModule(
          title: 'Juros Compostos',
          description: 'O que são e como podem trabalhar a seu favor.',
        ),
        CourseModule(
          title: 'Consumo Consciente',
          description: 'Gaste com propósito e evite dívidas.',
        ),
      ],
    ),
  ];
}
