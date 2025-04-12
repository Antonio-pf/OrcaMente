import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orcamente/components/widgets/game/obstacle.dart';
import 'package:orcamente/components/widgets/game/promotion.dart';
import 'package:orcamente/components/widgets/game/game_stats_bar.dart';
import 'package:orcamente/components/widgets/game/player_character.dart';
import 'package:orcamente/components/widgets/game/game_tutorial.dart';
import 'package:orcamente/controllers/game_controller.dart';

class EndlessRunnerGame extends StatefulWidget {
  const EndlessRunnerGame({super.key});

  @override
  State<EndlessRunnerGame> createState() => _EndlessRunnerGameState();
}

class _EndlessRunnerGameState extends State<EndlessRunnerGame> with TickerProviderStateMixin {
  late GameController _controller;
  late AnimationController _playerAnimController;
  bool _showTutorial = true;
  bool _isPaused = false;
  bool _gameOverShown = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    
    // Configurar animação do personagem
    _playerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    
    // Iniciar o jogo após o primeiro frame
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
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.red.shade300, Colors.red.shade700],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Fim de Jogo",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Você ficou sem dinheiro!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.yellow),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Dica: Sempre tenha uma reserva para imprevistos e evite dívidas desnecessárias.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _controller.restart(screenWidth, screenHeight);
                            _gameOverShown = false;
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Reiniciar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.exit_to_app),
                          label: const Text("Sair"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _controller.pause();
        _playerAnimController.stop();
      } else {
        _controller.resume();
        _playerAnimController.repeat(reverse: true);
      }
    });
  }

  void _handleJump() {
    if (!_isPaused) {
      _controller.handleJump();
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _playerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo do jogo com paralaxe
          _buildParallaxBackground(screenWidth, screenHeight),
          
          // Área de jogo principal
          GestureDetector(
            onTap: _handleJump,
            onVerticalDragStart: (_) => _handleJump(),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  // Obstáculos (dívidas)
                  _buildObstacles(),
                  
                  // Promoções (etiquetas educativas)
                  _buildPromotions(),
                  
                  // Jogador
                  _buildPlayer(),
                  
                  // Chão
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            20,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 4,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Barra de status com dinheiro, felicidade, conhecimento
                  _buildStatsBar(),
                  
                  // Texto de feedback
                  _buildFeedbackText(),
                  
                  // Botão de pausa
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Material(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: _togglePause,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            _isPaused ? Icons.play_arrow : Icons.pause,
                            color: Colors.green[700],
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Pontuação
                  ValueListenableBuilder<int>(
                    valueListenable: _controller.score,
                    builder: (_, score, __) {
                      return Positioned(
                        top: 40,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber[700], size: 24),
                              const SizedBox(width: 8),
                              Text(
                                score.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Tela de pausa
          if (_isPaused)
            Container(
              color: Colors.black.withOpacity(0.7),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "JOGO PAUSADO",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _togglePause,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Continuar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        _controller.restart(screenWidth, screenHeight);
                        setState(() {
                          _isPaused = false;
                          _playerAnimController.repeat(reverse: true);
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reiniciar"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text("Sair"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Tutorial inicial
          if (_showTutorial)
            GameTutorial(
              onDismiss: () {
                setState(() {
                  _showTutorial = false;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildParallaxBackground(double screenWidth, double screenHeight) {
    return Stack(
      children: [
        // Céu
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue[300]!, Colors.lightBlue[100]!],
            ),
          ),
        ),
        
        /*
        // Nuvens distantes (movimento lento)
        ValueListenableBuilder(
          valueListenable: _controller.backgroundX1,
          builder: (_, x1, __) {
            return Positioned(
              left: x1 / 3, // Movimento mais lento para criar efeito de profundidade
              top: screenHeight * 0.1,
              child: Image.asset(
                'assets/images/clouds.',
                width: screenWidth * 1.5,
                height: screenHeight * 0.3,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
        */
        // Prédios de fundo (movimento médio) tratar imagem e fundo
        /*
        ValueListenableBuilder(
          valueListenable: _controller.backgroundX1,
          builder: (_, x1, __) {
            return Positioned(
              left: x1 / 1.5,
              bottom: 80,
              child: Image.asset(
                'assets/images/florest.jpg',
                width: screenWidth * 1.5,
                height: screenHeight * 0.4,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
        */

        /*
        // Prédios de frente (movimento rápido)
        ValueListenableBuilder(
          valueListenable: _controller.backgroundX1,
          builder: (_, x1, __) {
            return Positioned(
              left: x1,
              bottom: 80,
              child: Image.asset(
                'assets/images/city_foreground.png',
                width: screenWidth * 1.5,
                height: screenHeight * 0.3,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
        
        */
        /*
        // Segunda cópia para movimento contínuo
        ValueListenableBuilder(
          valueListenable: _controller.backgroundX2,
          builder: (_, x2, __) {
            return Positioned(
              left: x2,
              bottom: 80,
              child: Image.asset(
                'assets/images/city_foreground.png',
                width: screenWidth * 1.5,
                height: screenHeight * 0.3,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
        */
      ],
    );
  }

  Widget _buildObstacles() {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: _controller.obstacles,
      builder: (_, obstacles, __) {
        return Stack(
          children: obstacles.map((o) {
            return Positioned(
              left: o["x"],
              bottom: 80,
              child: Obstacle(
                tipoDivida: o["label"] ?? "",
                valor: o["valor"] ?? 100,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPromotions() {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: _controller.promotions,
      builder: (_, promotions, __) {
        return Stack(
          children: promotions.map((p) {
            return Positioned(
              left: p["x"],
              bottom: p["y"] * MediaQuery.of(context).size.height,
              child: PromotionWidget(
                text: p["text"] ?? "",
                value: p["value"] ?? 25,
                collected: p["collected"] ?? false,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPlayer() {
    return ValueListenableBuilder(
      valueListenable: _controller.playerY,
      builder: (_, y, __) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          alignment: Alignment(-0.7, y),
          child: PlayerCharacter(
            animationController: _playerAnimController,
            isJumping: _controller.isJumping,
          ),
        );
      },
    );
  }

  Widget _buildStatsBar() {
    return ValueListenableBuilder<double>(
      valueListenable: _controller.dinheiro,
      builder: (_, dinheiro, __) {
        checkGameOver(dinheiro);
        return ValueListenableBuilder<int>(
          valueListenable: _controller.felicidade,
          builder: (_, felicidade, __) {
            return ValueListenableBuilder<int>(
              valueListenable: _controller.conhecimento,
              builder: (_, conhecimento, __) {
                return Positioned(
                  top: 100,
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
    );
  }

  Widget _buildFeedbackText() {
    return ValueListenableBuilder(
      valueListenable: _controller.feedbackText,
      builder: (_, feedback, __) {
        if (feedback.isEmpty) return const SizedBox.shrink();
        
        return Positioned(
          top: 160,
          left: 0,
          right: 0,
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: feedback.contains("-") 
                            ? Colors.red.withOpacity(0.8)
                            : Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        feedback,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
