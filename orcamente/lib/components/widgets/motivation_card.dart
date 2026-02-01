import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:orcamente/styles/custom_theme.dart';

class MotivationCard extends StatefulWidget {
  const MotivationCard({super.key});

  @override
  State<MotivationCard> createState() => _MotivationCardState();
}

class _MotivationCardState extends State<MotivationCard> {
  String quote = 'Carregando...';
  String author = '';
  late Timer _timer;
  bool _isBlurring = false;

  @override
  void initState() {
    super.initState();
    _loadMotivation();

    _timer = Timer.periodic(const Duration(seconds: 25), (_) {
      _loadMotivation();
    });
  }

  Future<void> _loadMotivation() async {
    setState(() => _isBlurring = true);

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final response = await http.get(
        Uri.parse('https://moraislucas.github.io/MeMotive/phrases.json'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final random = Random();
          final randomPhrase = data[random.nextInt(data.length)];

          setState(() {
            quote = '“${randomPhrase['quote']}”';
            author = '- ${randomPhrase['author']}';
          });
        }
      } else {
        setState(() {
          quote = 'Erro ao carregar frase.';
          author = '';
        });
      }
    } catch (e) {
      setState(() {
        quote = 'Erro ao conectar à internet.';
        author = '';
      });
    }

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isBlurring = false);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(quote),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomTheme.warningColor.withOpacity(0.1),
                border: Border.all(color: CustomTheme.warningColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.tips_and_updates,
                        color: CustomTheme.warningColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Dica do dia',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.warningColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(quote, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      author,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isBlurring)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.transparent),
              ),
            ),
        ],
      ),
    );
  }
}
