import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:orcamente/controllers/course_controller.dart';
import 'package:orcamente/styles/custom_theme.dart';

class PostQuizResultPage extends StatelessWidget {
  final int postScore;

  const PostQuizResultPage({super.key, required this.postScore});

  @override
  Widget build(BuildContext context) {
    final course = context.read<CourseController>().course;
    // pre_score range: 0–10 (quiz inicial, 5 perguntas × score 0/1/2)
    // post_score range: 0–10 (post-quiz, 5 perguntas × score 0/1/2)
    // Exibe como percentual: (10 - score) / 10 × 100
    // Score menor = mais conhecimento (por design do quiz original)
    final prePercent = ((10 - _estimatedPreScore(course?.profile)) / 10 * 100).clamp(0, 100).toInt();
    final postPercent = ((10 - postScore) / 10 * 100).clamp(0, 100).toInt();
    final delta = postPercent - prePercent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado Final'),
        backgroundColor: CustomTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 12),
            const Text(
              'Trilha Concluída!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              delta >= 0
                  ? 'Você melhorou $delta pontos percentuais no seu conhecimento financeiro.'
                  : 'Continue estudando — cada passo conta!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Antes',
                                  style: TextStyle(fontSize: 13));
                            case 1:
                              return const Text('Depois',
                                  style: TextStyle(fontSize: 13));
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 25,
                        getTitlesWidget: (value, meta) =>
                            Text('${value.toInt()}%',
                                style: const TextStyle(fontSize: 11)),
                      ),
                    ),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: prePercent.toDouble(),
                          color: Colors.orange.shade400,
                          width: 40,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6)),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: postPercent.toDouble(),
                          color: CustomTheme.primaryColor,
                          width: 40,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ScoreChip(label: 'Antes', value: '$prePercent%', color: Colors.orange.shade400),
                _ScoreChip(label: 'Depois', value: '$postPercent%', color: CustomTheme.primaryColor),
                _ScoreChip(
                  label: 'Melhora',
                  value: '${delta >= 0 ? '+' : ''}$delta%',
                  color: delta >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Voltar ao Início'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _estimatedPreScore(String? profile) {
    switch (profile) {
      case 'Gastador':
        return 8;
      case 'Poupador':
        return 5;
      case 'Investidor':
        return 2;
      default:
        return 5;
    }
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ScoreChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
