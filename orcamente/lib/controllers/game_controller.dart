import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:orcamente/utils/game/promotion_generation.dart';

class GameController {
  Timer? gameLoop;

  final ValueNotifier<double> playerY = ValueNotifier(0.82);
  final ValueNotifier<double> backgroundX1 = ValueNotifier(0);
  final ValueNotifier<double> backgroundX2 = ValueNotifier(0);

  final ValueNotifier<double> dinheiro = ValueNotifier(300.0);
  final ValueNotifier<int> felicidade = ValueNotifier(100);
  final ValueNotifier<int> conhecimento = ValueNotifier(0);
  final ValueNotifier<int> score = ValueNotifier(0);

  final ValueNotifier<String> feedbackText = ValueNotifier("");
  final ValueNotifier<List<Map<String, dynamic>>> obstacles = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> promotions = ValueNotifier([]);

  double? _screenWidth;
  double? _screenHeight;

  double velocity = 0;
  final double gravity = 0.006;
  final double jumpForce = -0.07;
  final double maxFallSpeed = 0.02;
  bool isJumping = false;
  int jumpCount = 0;
  double backgroundSpeed = 4;
  int _difficultyLevel = 1;
  int _obstacleCounter = 0;
  int _scoreCounter = 0;
  Timer? _feedbackTimer;
  
  // Power-ups e efeitos
  bool _hasShield = false;
  Timer? _shieldTimer;
  bool _hasSpeedBoost = false;
  Timer? _speedBoostTimer;
  int _combo = 0;
  Timer? _comboTimer;
  
  // Dificuldade progressiva
  final int _pointsPerLevel = 300;
  final double _speedIncreasePerLevel = 0.7;
  final double _maxSpeed = 10.0;
  final double _minSpeed = 4.0;

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

    // Atualizar posição do jogador (pulo) com física melhorada
    if (isJumping) {
      velocity += gravity;
      
      // Limitar velocidade de queda
      if (velocity > maxFallSpeed) {
        velocity = maxFallSpeed;
      }
      
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
    int newLevel = (score.value / _pointsPerLevel).floor() + 1;
    if (newLevel > _difficultyLevel) {
      _difficultyLevel = newLevel;
      
      // Calcular nova velocidade com boost temporário se ativo
      double baseSpeed = min(_maxSpeed, _minSpeed + (_difficultyLevel - 1) * _speedIncreasePerLevel);
      backgroundSpeed = _hasSpeedBoost ? baseSpeed * 0.7 : baseSpeed;
      
      // Mostrar feedback de aumento de dificuldade
      showFeedback("🎯 Nível $_difficultyLevel! Velocidade aumentada!", isPositive: true);
      
      // Recompensas por nível
      conhecimento.value = min(100, conhecimento.value + 5);
      dinheiro.value += 50 * _difficultyLevel;
      felicidade.value = min(100, felicidade.value + 3);
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
        
        if (_hasShield) {
          // Escudo absorve o impacto
          showFeedback("🛡️ Escudo protegeu você!", isPositive: true);
          _removeShield();
        } else {
          // Dano normal
          int valor = obstacle["valor"] ?? 100;
          dinheiro.value -= valor;
          felicidade.value = max(0, felicidade.value - 10);
          
          // Resetar combo
          _resetCombo();
          
          // Feedback com o valor específico da dívida
          showFeedback("💥 Dívida: -R\$$valor", isPositive: false);
        }
        
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
          
          // Aumentar combo
          _incrementCombo();
          
          // Aplicar multiplicador de combo
          int bonusValue = (value * (1 + _combo * 0.1)).round();
          dinheiro.value += bonusValue;
          conhecimento.value = min(100, conhecimento.value + 2);
          felicidade.value = min(100, felicidade.value + 5);
          
          // Adicionar pontos extras com combo
          int bonusPoints = 10 * (1 + _combo);
          score.value += bonusPoints;
          
          String comboText = _combo > 1 ? " (Combo x$_combo!)" : "";
          showFeedback("✨ Dica: +R\$$bonusValue$comboText", isPositive: true);
        }
      }
    }
    promotions.value = proms;
  }

  void showFeedback(String message, {bool isPositive = false}) {
    feedbackText.value = message;
    
    // Cancelar timer anterior se existir
    _feedbackTimer?.cancel();
    
    // Definir novo timer para limpar o feedback após 2 segundos
    _feedbackTimer = Timer(const Duration(milliseconds: 2000), () {
      feedbackText.value = "";
    });
  }
  
  void _incrementCombo() {
    _combo++;
    _comboTimer?.cancel();
    
    // Resetar combo após 3 segundos sem coletar
    _comboTimer = Timer(const Duration(seconds: 3), () {
      _resetCombo();
    });
  }
  
  void _resetCombo() {
    _combo = 0;
    _comboTimer?.cancel();
  }
  
  void activateShield() {
    _hasShield = true;
    showFeedback("🛡️ Escudo ativado!", isPositive: true);
    
    _shieldTimer?.cancel();
    _shieldTimer = Timer(const Duration(seconds: 10), () {
      _removeShield();
    });
  }
  
  void _removeShield() {
    _hasShield = false;
    _shieldTimer?.cancel();
  }
  
  void activateSpeedBoost() {
    _hasSpeedBoost = true;
    backgroundSpeed *= 0.7; // Reduz velocidade em 30%
    showFeedback("⚡ Slow Motion ativado!", isPositive: true);
    
    _speedBoostTimer?.cancel();
    _speedBoostTimer = Timer(const Duration(seconds: 8), () {
      _removeSpeedBoost();
    });
  }
  
  void _removeSpeedBoost() {
    if (_hasSpeedBoost) {
      _hasSpeedBoost = false;
      backgroundSpeed = min(_maxSpeed, _minSpeed + (_difficultyLevel - 1) * _speedIncreasePerLevel);
      _speedBoostTimer?.cancel();
    }
  }
  
  bool get hasShield => _hasShield;
  bool get hasSpeedBoost => _hasSpeedBoost;
  int get combo => _combo;

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
    gameLoop?.cancel();

    playerY.value = 0.82;
    backgroundX1.value = 0;
    backgroundX2.value = screenWidth;
    dinheiro.value = 300.0;
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
    _shieldTimer?.cancel();
    _speedBoostTimer?.cancel();
    _comboTimer?.cancel();
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
