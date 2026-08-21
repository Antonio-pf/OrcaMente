import 'package:flutter_test/flutter_test.dart';
import 'package:orcamente/models/generated_course.dart';

void main() {
  final sampleMap = {
    'profile': 'Gastador',
    'city': 'Fortaleza',
    'state': 'CE',
    'generatedAt': '2026-08-21T10:00:00.000Z',
    'practicalTips': ['Dica 1', 'Dica 2'],
    'completedModuleIds': <String>[],
    'postQuizScore': null,
    'topics': [
      {
        'id': 't1',
        'title': 'Controle de Gastos',
        'description': 'Aprenda a controlar',
        'modules': [
          {
            'id': 'm1',
            'title': 'Orçamento',
            'content': 'Conteúdo do módulo',
            'estimatedTime': '10 min',
          },
          {
            'id': 'm2',
            'title': 'Reserva',
            'content': 'Conteúdo da reserva',
            'estimatedTime': '15 min',
          },
        ],
      },
    ],
  };

  test('GeneratedCourse.fromMap deserializa corretamente', () {
    final course = GeneratedCourse.fromMap(sampleMap);
    expect(course.profile, 'Gastador');
    expect(course.city, 'Fortaleza');
    expect(course.topics.length, 1);
    expect(course.topics.first.modules.length, 2);
  });

  test('totalModules retorna soma de todos os módulos', () {
    final course = GeneratedCourse.fromMap(sampleMap);
    expect(course.totalModules, 2);
  });

  test('progressPercent é 0.0 quando nenhum módulo concluído', () {
    final course = GeneratedCourse.fromMap(sampleMap);
    expect(course.progressPercent, 0.0);
  });

  test('progressPercent é 0.5 quando metade concluída', () {
    final course = GeneratedCourse.fromMap(sampleMap)
        .copyWith(completedModuleIds: ['m1']);
    expect(course.progressPercent, 0.5);
  });

  test('isFullyCompleted é true quando todos os módulos concluídos', () {
    final course = GeneratedCourse.fromMap(sampleMap)
        .copyWith(completedModuleIds: ['m1', 'm2']);
    expect(course.isFullyCompleted, true);
  });

  test('toMap e fromMap são simétricos', () {
    final original = GeneratedCourse.fromMap(sampleMap);
    final roundtrip = GeneratedCourse.fromMap(original.toMap());
    expect(roundtrip.profile, original.profile);
    expect(roundtrip.topics.length, original.topics.length);
    expect(roundtrip.totalModules, original.totalModules);
  });
}
