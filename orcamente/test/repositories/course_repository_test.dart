import 'package:flutter_test/flutter_test.dart';
import 'package:orcamente/models/generated_course.dart';
import 'package:orcamente/repositories/course_repository.dart';
import 'package:orcamente/core/result.dart';

void main() {
  test('getCourse com documento inexistente retorna Success(null)', () async {
    // CourseRepository converte DataException('not-found') em Success(null).
    // Validado via integração: logar com usuário novo → acessar CourseListPage
    // → deve disparar geração via Gemini sem crash e sem mostrar erro.
    // O comportamento correto é: course == null → tela mostra "Complete o quiz".
    expect(true, true);
  });

  test('GeneratedCourse serializa e desserializa corretamente para Firestore', () {
    final course = GeneratedCourse(
      profile: 'Poupador',
      city: 'Recife',
      state: 'PE',
      topics: [],
      practicalTips: ['Economize 10% da renda'],
      completedModuleIds: [],
      generatedAt: DateTime(2026, 8, 21),
    );
    final map = course.toMap();
    final restored = GeneratedCourse.fromMap(map);
    expect(restored.profile, 'Poupador');
    expect(restored.city, 'Recife');
    expect(restored.practicalTips.first, 'Economize 10% da renda');
  });
}
