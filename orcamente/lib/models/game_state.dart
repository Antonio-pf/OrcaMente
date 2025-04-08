import 'dart:math';


class GameState {
  double playerY = 0.82;
  double velocity = 0;
  double gravity = 0.0099;
  double jumpForce = -0.12;
  bool isJumping = false;
  int jumpCount = 0;

  double backgroundX1 = 0;
  double backgroundX2 = 0;
  double backgroundSpeed = 3;

  double dinheiro = 1500.0;

  List<Map<String, dynamic>> obstacles = [];
  List<Map<String, dynamic>> promotions = [];

  final List<String> promoTexts = [
    "Buy 1 Get 1",
    "Flash Sale",
    "30% Off Shoes",
    "Free Shipping",
  ];
  final List<String> tiposDivida = [
    "Conta de Luz",
    "Empréstimo",
    "Assinatura",
    "Parcelado",
  ];

  late double screenWidth;

  void init(double screenWidth) {
    this.screenWidth = screenWidth;

    obstacles = [
      {"x": screenWidth + 100.0, "label": "Conta de Luz", "collided": false},
      {"x": screenWidth + 400.0, "label": "Empréstimo", "collided": false},
    ];

    promotions = [
      {"x": screenWidth + 250.0, "y": 0.5, "text": "30% Off"},
      {"x": screenWidth + 700.0, "y": 0.6, "text": "Free Shipping"},
    ];

    backgroundX2 = screenWidth;
  }

  void update() {
    backgroundX1 -= backgroundSpeed;
    backgroundX2 -= backgroundSpeed;

    if (backgroundX1 <= -screenWidth) backgroundX1 = backgroundX2 + screenWidth;
    if (backgroundX2 <= -screenWidth) backgroundX2 = backgroundX1 + screenWidth;

    if (isJumping) {
      velocity += gravity;
      playerY += velocity;

      if (playerY >= 0.82) {
        playerY = 0.82;
        isJumping = false;
        velocity = 0;
        jumpCount = 0;
      }
    }

    for (var obstacle in obstacles) {
      obstacle["x"] -= backgroundSpeed;

      // Resetar obstáculo se sair da tela
      if (obstacle["x"] < -100) {
        obstacle["x"] = screenWidth + (obstacles.indexOf(obstacle) * 300);
        obstacle["label"] = tiposDivida[Random().nextInt(tiposDivida.length)];
        obstacle["collided"] = false;
      }

      // Colisão precisa
      const double playerX = 70;
      const double playerWidth = 40;
      const double playerHeight = 0.15;
      double playerTop = playerY;
      double playerBottom = playerY + playerHeight;

      double obstacleX = obstacle["x"];
      const double obstacleWidth = 25;

      const double iconTopY = 0.75;
      const double iconHeight = 0.07;
      double iconBottom = iconTopY + iconHeight;

      bool horizontalOverlap = playerX < obstacleX + obstacleWidth &&
                               playerX + playerWidth > obstacleX;

      bool verticalOverlap = playerBottom >= iconTopY && playerTop <= iconBottom;

      if (horizontalOverlap && verticalOverlap && !obstacle["collided"]) {
        dinheiro -= 100;
        obstacle["collided"] = true;
      }
    }

    for (var promo in promotions) {
      promo["x"] -= backgroundSpeed;

      if (promo["x"] < -150) {
        promo["x"] = screenWidth + 600;
        promo["text"] = promoTexts[Random().nextInt(promoTexts.length)];
      }

      double promoY = promo["y"];
      if (promo["x"] < 100 && promo["x"] > 0) {
        if (playerY < promoY + 0.05 && playerY > promoY - 0.1) {
          dinheiro -= 50;
        } else if (playerY < 0.82) {
          dinheiro += 25;
        }
      }
    }
  }

  void jump() {
    if (jumpCount < 2) {
      isJumping = true;
      velocity = jumpForce;
      jumpCount++;
    }
  }
}
