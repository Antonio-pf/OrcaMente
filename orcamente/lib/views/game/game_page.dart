import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/game/obstacle.dart';
import 'package:orcamente/components/widgets/game/promotion.dart';
import 'package:orcamente/components/widgets/game/game_stats_bar.dart';
import 'package:orcamente/controllers/game_controller.dart';

class EndlessRunnerGame extends StatefulWidget {
  const EndlessRunnerGame({super.key});

  @override
  State<EndlessRunnerGame> createState() => _EndlessRunnerGameState();
}

class _EndlessRunnerGameState extends State<EndlessRunnerGame> {
  late GameController _controller;

  DateTime? lastTap;
  final int doubleTapThresholdMs = 300;

  bool _gameOverShown = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      _controller.start(screenWidth, screenHeight);
    });
  }

void checkGameOver(double dinheiro) {
  if (dinheiro < 0 && !_gameOverShown) {
    _gameOverShown = true;
    _controller.stop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Fim de Jogo"),
            content: const Text(
              "Você ficou sem dinheiro!\n\n💡 Dica: Sempre tenha uma reserva para imprevistos e evite dívidas desnecessárias.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); 
                  _controller.restart(screenWidth, screenHeight); 
                  _gameOverShown = false;
                },
                child: const Text("Reiniciar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); 
                  _gameOverShown = false;
                },
                child: const Text("Fechar"),
              ),
            ],
          );
        },
      );
    });
  }
}



  void onTapDownHandler() {
    final now = DateTime.now();
    if (lastTap != null &&
        now.difference(lastTap!) < Duration(milliseconds: doubleTapThresholdMs)) {
      _controller.handleJump();
      lastTap = null;
    } else {
      _controller.handleJump();
      lastTap = now;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: GestureDetector(
        onTapDown: (_) => onTapDownHandler(),
        child: Stack(
          children: [
            // Fundo 1
            ValueListenableBuilder(
              valueListenable: _controller.backgroundX1,
              builder: (_, x1, __) {
                return Positioned(
                  left: x1,
                  top: 0,
                  child: Image.asset(
                    'assets/images/1.jpg',
                    width: screenWidth,
                    height: screenHeight,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

            // Fundo 2
            ValueListenableBuilder(
              valueListenable: _controller.backgroundX2,
              builder: (_, x2, __) {
                return Positioned(
                  left: x2,
                  top: 0,
                  child: Image.asset(
                    'assets/images/1.jpg',
                    width: screenWidth,
                    height: screenHeight,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

            // Obstáculos
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: _controller.obstacles,
              builder: (_, obstacles, __) {
                return Stack(
                  children: obstacles.map((o) {
                    return Positioned(
                      left: o["x"],
                      bottom: 80,
                      child: Obstacle(tipoDivida: o["label"] ?? ""),
                    );
                  }).toList(),
                );
              },
            ),

            // Promoções
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: _controller.promotions,
              builder: (_, promotions, __) {
                return Stack(
                  children: promotions.map((p) {
                    return Positioned(
                      left: p["x"],
                      bottom: p["y"] * screenHeight,
                      child: PromotionWidget(text: p["text"] ?? ""),
                    );
                  }).toList(),
                );
              },
            ),

            // Jogador
            ValueListenableBuilder(
              valueListenable: _controller.playerY,
              builder: (_, y, __) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(-0.9, y),
                  child: const Icon(Icons.account_circle,
                      size: 60, color: Colors.deepPurple),
                );
              },
            ),

            // Chão
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                color: Colors.green[600],
              ),
            ),

            // Barra de status com dinheiro, felicidade, conhecimento
            ValueListenableBuilder<double>(
              valueListenable: _controller.dinheiro,
              builder: (_, dinheiro, __) {
                checkGameOver(dinheiro); // 👈 aqui que detecta o game over
                return ValueListenableBuilder<int>(
                  valueListenable: _controller.felicidade,
                  builder: (_, felicidade, __) {
                    return ValueListenableBuilder<int>(
                      valueListenable: _controller.conhecimento,
                      builder: (_, conhecimento, __) {
                        return Positioned(
                          top: 40,
                          left: 0,
                          right: 0,
                          child: GameStatsBar(
                            money: dinheiro.toInt(),
                            happiness: felicidade,
                            knowledge: conhecimento,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            // Texto de feedback
            ValueListenableBuilder(
              valueListenable: _controller.feedbackText,
              builder: (_, feedback, __) {
                return Positioned(
                  top: 100,
                  left: 20,
                  child: Text(
                    "Tap ou double tap para pular\n$feedback",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
