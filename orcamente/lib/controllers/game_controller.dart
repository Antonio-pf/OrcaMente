import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:orcamente/utils/game/promotion_generation.dart';

class GameController {
  Timer? gameLoop;

  final ValueNotifier<double> playerY = ValueNotifier(0.82);
  final ValueNotifier<double> backgroundX1 = ValueNotifier(0);
  final ValueNotifier<double> backgroundX2 = ValueNotifier(0);

  final ValueNotifier<double> dinheiro = ValueNotifier(1500.0);
  final ValueNotifier<int> felicidade = ValueNotifier(100);
  final ValueNotifier<int> conhecimento = ValueNotifier(0);
  final ValueNotifier<int> score = ValueNotifier(0);

  final ValueNotifier<String> feedbackText = ValueNotifier("");
  final ValueNotifier<List<Map<String, dynamic>>> obstacles = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> promotions = ValueNotifier([]);

  double? _screenWidth;
  double? _screenHeight;

  double velocity = 0;
  final double gravity = 0.0055;
  final double jumpForce = -0.0601;
  bool isJumping = false;
  int jumpCount = 0;
  double backgroundSpeed = 3;
  int _difficultyLevel = 1;
  int _obstacleCounter = 0;
  int _scoreCounter = 0;
  Timer? _feedbackTimer;
  
  // Dificuldade progressiva
  final int _pointsPerLevel = 500;
  final double _speedIncreasePerLevel = 0.5;
  final double _maxSpeed = 8.0;

  final Random _random = Random();

  final List<String> promoTexts = [
    "Economize",
    "Invista",
    "Planeje",
    "Poupe",
    "Orçamento",
    "Educação",
    "Reserva",
    "Controle",
  ];

  final List<Map<String, dynamic>> tiposDivida = [
    {"label": "Conta de Luz", "valor": 100},
    {"label": "Empréstimo", "valor": 200},
    {"label": "Assinatura", "valor": 50},
    {"label": "Parcelado", "valor": 150},
    {"label": "Cartão", "valor": 180},
    {"label": "Aluguel", "valor": 250},
    {"label": "Imposto", "valor": 120},
    {"label": "Multa", "valor": 80},
  ];

  late double screenHeight;

  void start(double screenWidth, double screenHeight) {
    this._screenWidth = screenWidth;
    this._screenHeight = screenHeight;
    this.screenHeight = screenHeight;
    backgroundX2.value = screenWidth;

    obstacles.value = [
      {
        "x": screenWidth + 100.0, 
        "label": "Conta de Luz", 
        "valor": 100,
        "collided": false
      },
      {
        "x": screenWidth + 400.0, 
        "label": "Empréstimo", 
        "valor": 200,
        "collided": false
      },
    ];

    promotions.value = [
      generatePromotion(screenWidth),
      generatePromotion(screenWidth + 450),
    ];

    startGameLoop();
  }

  void startGameLoop() {
    gameLoop = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _updateGame();
    });
  }

  void _updateGame() {
    // Atualizar posição do fundo
    backgroundX1.value -= backgroundSpeed;
    backgroundX2.value -= backgroundSpeed;

    if (backgroundX1.value <= -(_screenWidth ?? 0)) {
      backgroundX1.value = backgroundX2.value + (_screenWidth ?? 0);
    }
    if (backgroundX2.value <= -(_screenWidth ?? 0)) {
      backgroundX2.value = backgroundX1.value + (_screenWidth ?? 0);
    }

    // Atualizar posição do jogador (pulo)
    if (isJumping) {
      velocity += gravity;
      playerY.value += velocity;

      if (playerY.value >= 0.82) {
        playerY.value = 0.82;
        isJumping = false;
        velocity = 0;
        jumpCount = 0;
      }
    }

    // Verificar colisões
    _checkCollisions();
    
    // Atualizar pontuação
    _scoreCounter++;
    if (_scoreCounter >= 30) { // A cada ~0.5 segundo
      score.value += 1;
      _scoreCounter = 0;
      
      // Verificar aumento de dificuldade
      _checkDifficultyIncrease();
    }
  }
  
  void _checkDifficultyIncrease() {
int newLevel = (score.value / _pointsPerLevel).floor() + 1;    if (newLevel > _difficultyLevel) {
      _difficultyLevel = newLevel;
      backgroundSpeed = min(_maxSpeed, 3 + (_difficultyLevel - 1) * _speedIncreasePerLevel);
      
      // Mostrar feedback de aumento de dificuldade
      showFeedback("Nível $_difficultyLevel! Velocidade aumentada!");
      
      // Aumentar conhecimento a cada nível
      conhecimento.value = min(100, conhecimento.value + 5);
    }
  }

  void _checkCollisions() {
    if (_screenWidth == null || _screenHeight == null) return;
    
    double playerX = _screenWidth! * 0.15;
    const double playerWidth = 40;
    const double playerHeightPct = 0.15;
    double playerTopPx = playerY.value * _screenHeight!;
    double playerHeightPx = playerHeightPct * _screenHeight!;
    Rect playerRect = Rect.fromLTWH(
      playerX,
      playerTopPx,
      playerWidth,
      playerHeightPx,
    );

    // Verificar colisões com obstáculos
    final obs = List<Map<String, dynamic>>.from(obstacles.value);
    for (var obstacle in obs) {
      obstacle["x"] -= backgroundSpeed;

      // Reposicionar obstáculo quando sair da tela
      if (obstacle["x"] < -100) {
        _obstacleCounter++;
        
        // Aumentar a distância entre obstáculos com base na dificuldade
        double baseDistance = 300;
        double randomVariation = _random.nextDouble() * 100;
        double distanceMultiplier = max(0.7, 1.0 - (_difficultyLevel * 0.05)); // Diminui gradualmente
        
        obstacle["x"] = _screenWidth! + (baseDistance * distanceMultiplier) + randomVariation;
        
        // Selecionar um tipo de dívida aleatório
        final selectedDebt = tiposDivida[_random.nextInt(tiposDivida.length)];
        obstacle["label"] = selectedDebt["label"];
        obstacle["valor"] = selectedDebt["valor"];
        obstacle["collided"] = false;
      }

      // Verificar colisão
      double obstacleX = obstacle["x"];
      const double obstacleWidth = 40;
      const double obstacleHeightPct = 0.08;
      double obstacleTopPx = 0.82 * _screenHeight!;
      double obstacleHeightPx = obstacleHeightPct * _screenHeight!;
      Rect obstacleRect = Rect.fromLTWH(
        obstacleX,
        obstacleTopPx,
        obstacleWidth,
        obstacleHeightPx,
      );

      if (playerRect.overlaps(obstacleRect) && !obstacle["collided"]) {
        obstacle["collided"] = true;
        int valor = obstacle["valor"] ?? 100;
        dinheiro.value -= valor;
        felicidade.value = max(0, felicidade.value - 10);
        
        // Feedback com o valor específico da dívida
        showFeedback("Você bateu em uma dívida: -R\$$valor");
        
        // Efeito visual de colisão
        obstacle["hit"] = true;
      }
    }
    obstacles.value = obs;

    // Verificar colisões com promoções
    final proms = List<Map<String, dynamic>>.from(promotions.value);
    for (var promo in proms) {
      promo["x"] -= backgroundSpeed;

      // Reposicionar promoção quando sair da tela
      if (promo["x"] < -150) {
        final newPromo = generatePromotion(_screenWidth!);
        promo["x"] = newPromo["x"];
        promo["y"] = newPromo["y"];
        promo["text"] = newPromo["text"];
        promo["value"] = 25 + (_difficultyLevel * 5); // Valor aumenta com a dificuldade
        promo["collected"] = false;
      }

      // Verificar colisão
      const double promoWidth = 40;
      const double promoHeightPct = 0.08;
      double promoY = promo["y"];
      double promoTopPx = promoY * _screenHeight!;
      double promoHeightPx = promoHeightPct * _screenHeight!;
      Rect promoRect = Rect.fromLTWH(
        promo["x"],
        promoTopPx,
        promoWidth,
        promoHeightPx,
      );

      if (playerRect.overlaps(promoRect)) {
        if (promo["collected"] != true) {
          promo["collected"] = true;
          int value = promo["value"] ?? 25;
          dinheiro.value += value;
          conhecimento.value = min(100, conhecimento.value + 2);
          felicidade.value = min(100, felicidade.value + 5);
          
          // Adicionar pontos extras
          score.value += 10;
          
          showFeedback("Você coletou uma dica: +R\$$value");
        }
      }
    }
    promotions.value = proms;
  }

  void showFeedback(String message) {
    feedbackText.value = message;
    
    // Cancelar timer anterior se existir
    _feedbackTimer?.cancel();
    
    // Definir novo timer para limpar o feedback após 2 segundos
    _feedbackTimer = Timer(const Duration(seconds: 2), () {
      feedbackText.value = "";
    });
  }

  void handleJump() {
    if (jumpCount < 2) {
      isJumping = true;
      velocity = jumpForce;
      jumpCount++;
    }
  }

  void pause() {
    gameLoop?.cancel();
  }

  void resume() {
    if (gameLoop == null || !gameLoop!.isActive) {
      startGameLoop();
    }
  }

  void stop() {
    gameLoop?.cancel();
  }

  void restart(double screenWidth, double screenHeight) {
    // Cancela o loop atual se estiver ativo
    gameLoop?.cancel();

    // Reseta todas as variáveis
    playerY.value = 0.82;
    backgroundX1.value = 0;
    backgroundX2.value = screenWidth;
    dinheiro.value = 1500.0;
    felicidade.value = 100;
    conhecimento.value = 0;
    score.value = 0;
    feedbackText.value = "";

    velocity = 0;
    isJumping = false;
    jumpCount = 0;
    backgroundSpeed = 3;
    _difficultyLevel = 1;
    _obstacleCounter = 0;
    _scoreCounter = 0;

    obstacles.value = [
      {
        "x": screenWidth + 100.0, 
        "label": "Conta de Luz", 
        "valor": 100,
        "collided": false
      },
      {
        "x": screenWidth + 400.0, 
        "label": "Empréstimo", 
        "valor": 200,
        "collided": false
      },
    ];

    promotions.value = [
      generatePromotion(screenWidth),
      generatePromotion(screenWidth + 450),
    ];

    // Inicia novamente o jogo
    start(screenWidth, screenHeight);
  }

  void dispose() {
    gameLoop?.cancel();
    _feedbackTimer?.cancel();
    playerY.dispose();
    backgroundX1.dispose();
    backgroundX2.dispose();
    dinheiro.dispose();
    felicidade.dispose();
    conhecimento.dispose();
    score.dispose();
    feedbackText.dispose();
    obstacles.dispose();
    promotions.dispose();
  }
}
