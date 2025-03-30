import 'package:flutter/material.dart';
import 'package:orcamente/styles/custom_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: CustomTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.attach_money_rounded,
                  color: CustomTheme.neutralWhite,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: CustomTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: CustomTheme.neutralWhite,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Objetivo do Aplicativo',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomTheme.neutralDarkGray,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(text: 'O '),
                            TextSpan(
                              text: 'OrçaMente',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.primaryColor,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' é um aplicativo de controle financeiro pessoal com foco em educação financeira. Seu objetivo é ajudar o usuário a:',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildObjetivoItem(
                        'Planejar seus gastos de forma inteligente',
                      ),
                      const SizedBox(height: 8),
                      _buildObjetivoItem(
                        'Controlar seu orçamento com facilidade',
                      ),
                      const SizedBox(height: 8),
                      _buildObjetivoItem(
                        'Alcançar suas metas financeiras com confiança',
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: CustomTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.people,
                              color: CustomTheme.neutralWhite,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Nossa Equipe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: CustomTheme.neutralLightGray,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: CustomTheme.neutralGray,
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Antônio Pires Felipe',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: CustomTheme.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Desenvolvedor Full Stack',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CustomTheme.neutralGray,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Abrir GitHub
                                    },
                                    child: const Icon(
                                      Icons.code,
                                      size: 20,
                                      color: CustomTheme.neutralGray,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () {
                                      // Abrir LinkedIn
                                    },
                                    child: const Icon(
                                      Icons.link,
                                      size: 20,
                                      color: CustomTheme.neutralGray,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                child: Container(
                  width:
                      double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: const [
                      Text(
                        'OrçaMente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.primaryDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Versão 1.0.0',
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomTheme.neutralGray,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '© 2025 OrçaMente. Todos os direitos reservados.',
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomTheme.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildObjetivoItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: CustomTheme.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lightbulb_outline,
            color: CustomTheme.primaryColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: CustomTheme.neutralDarkGray,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
