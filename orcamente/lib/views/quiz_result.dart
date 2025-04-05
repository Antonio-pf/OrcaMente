import 'package:flutter/material.dart';
import '../../styles/custom_theme.dart';

class QuizResultPage extends StatelessWidget {
  final String profile;
  final String knowledge;

  const QuizResultPage({
    super.key,
    required this.profile,
    required this.knowledge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileColor = _getProfileColor();
    final profileIcon = _getProfileIcon();

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado do Quiz')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: profileColor.withOpacity(0.15),
                      radius: 30,
                      child: Icon(profileIcon, color: profileColor, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text('Seu perfil é:', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      profile,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: profileColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nível de conhecimento:',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _getKnowledgeLevelValue(),
                      backgroundColor: CustomTheme.neutralLightGray,
                      valueColor: AlwaysStoppedAnimation(profileColor),
                    ),

                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        knowledge,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getKnowledgeColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre seu perfil:',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getProfileDescription(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Recomendações para você:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            _buildRecommendationTile(
              icon: Icons.show_chart,
              title: 'Diversificação de investimentos',
              context: context,
            ),
            _buildRecommendationTile(
              icon: Icons.school,
              title: 'Curso: Investimentos para iniciantes',
              context: context,
            ),
            _buildRecommendationTile(
              icon: Icons.calendar_today,
              title: 'Planejamento financeiro mensal',
              context: context,
            ),

            const SizedBox(height: 24),

            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationTile({
    required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {}, 
      ),
    );
  }

  Color _getProfileColor() {
    switch (profile) {
      case 'Gastador':
        return CustomTheme.errorColor;
      case 'Poupador':
        return CustomTheme.warningColor;
      case 'Investidor':
        return CustomTheme.successColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getProfileIcon() {
    switch (profile) {
      case 'Gastador':
        return Icons.shopping_cart;
      case 'Poupador':
        return Icons.savings;
      case 'Investidor':
        return Icons.trending_up;
      default:
        return Icons.person;
    }
  }

  double _getKnowledgeLevelValue() {
    switch (profile.toLowerCase()) {
      case 'gastador':
        return 0.33;
      case 'poupador':
        return 0.66;
      case 'investidor':
        return 1.0;
      default:
        return 0.0;
    }
  }

  Color _getKnowledgeColor() {
    switch (knowledge.toLowerCase()) {
      case 'iniciante':
        return Colors.redAccent;
      case 'intermediário':
        return Colors.amber;
      case 'avançado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getProfileDescription() {
    switch (profile) {
      case 'Gastador':
        return 'Como um Gastador, você tende a priorizar o consumo imediato e pode ter dificuldade em manter o controle dos gastos. '
            'É importante desenvolver hábitos de planejamento financeiro para evitar dívidas e alcançar seus objetivos.';
      case 'Poupador':
        return 'Como um Poupador, você tende a ser cauteloso com seus gastos e prioriza guardar dinheiro. '
            'Você valoriza a segurança financeira e prefere investimentos de baixo risco.\n\n'
            'Seu conhecimento $knowledge indica que você já compreende conceitos básicos de finanças, '
            'mas ainda pode aprender estratégias mais avançadas para otimizar seus investimentos.';
      case 'Investidor':
        return 'Como um Investidor, você está atento às oportunidades do mercado e busca fazer o dinheiro trabalhar por você. '
            'Você tem uma boa compreensão financeira e está disposto a correr riscos calculados para obter retorno.';
      default:
        return 'Perfil não identificado.';
    }
  }
}
