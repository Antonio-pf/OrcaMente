import 'dart:async';
import 'package:flutter/material.dart';
import 'package:orcamente/utils/game/promotion_generation.dart';

class GameController {
  late Timer gameLoop;

  final ValueNotifier<double> playerY = ValueNotifier(0.82);
  final ValueNotifier<double> backgroundX1 = ValueNotifier(0);
  final ValueNotifier<double> backgroundX2 = ValueNotifier(0);
  
  final ValueNotifier<double> dinheiro = ValueNotifier(1500.0);
final ValueNotifier<int> felicidade = ValueNotifier(100); // valor inicial
final ValueNotifier<int> conhecimento = ValueNotifier(0); // valor inicial

  final ValueNotifier<String> feedbackText = ValueNotifier("");
  final ValueNotifier<List<Map<String, dynamic>>> obstacles = ValueNotifier([]);
  final ValueNotifier<List<Map<String, dynamic>>> promotions = ValueNotifier(
    [],
  );

  double velocity = 0;
  final double gravity = 0.0055;
  final double jumpForce = -0.0601;
  bool isJumping = false;
  int jumpCount = 0;
  final double backgroundSpeed = 3;

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

  late double screenHeight;

  void start(double screenWidth, double screenHeight) {
    this.screenHeight = screenHeight;
    backgroundX2.value = screenWidth;

    obstacles.value = [
      {"x": screenWidth + 100.0, "label": "Conta de Luz", "collided": false},
      {"x": screenWidth + 400.0, "label": "Empréstimo", "collided": false},
    ];

    promotions.value = [
      generatePromotion(screenWidth),
      generatePromotion(screenWidth + 450),
    ];

    gameLoop = Timer.periodic(const Duration(milliseconds: 30), (_) {
      backgroundX1.value -= backgroundSpeed;
      backgroundX2.value -= backgroundSpeed;

      if (backgroundX1.value <= -screenWidth) {
        backgroundX1.value = backgroundX2.value + screenWidth;
      }
      if (backgroundX2.value <= -screenWidth) {
        backgroundX2.value = backgroundX1.value + screenWidth;
      }

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

      double playerX = screenWidth * 0.08;
      const double playerWidth = 40;
      const double playerHeightPct = 0.15;
      double playerTopPx = playerY.value * screenHeight;
      double playerHeightPx = playerHeightPct * screenHeight;
      Rect playerRect = Rect.fromLTWH(
        playerX,
        playerTopPx,
        playerWidth,
        playerHeightPx,
      );

      final obs = List<Map<String, dynamic>>.from(obstacles.value);
      for (var obstacle in obs) {
        obstacle["x"] -= backgroundSpeed;

        if (obstacle["x"] < -100) {
          obstacle["x"] = screenWidth + (obs.indexOf(obstacle) * 300);
          obstacle["label"] =
              tiposDivida[DateTime.now().millisecondsSinceEpoch %
                  tiposDivida.length];
          obstacle["collided"] = false;
        }

        double obstacleX = obstacle["x"];
        const double obstacleWidth = 30;
        const double iconTopYPct = 0.82;
        const double iconHeightPct = 0.08;
        double iconTopPx = iconTopYPct * screenHeight;
        double iconHeightPx = iconHeightPct * screenHeight;
        Rect obstacleRect = Rect.fromLTWH(
          obstacleX,
          iconTopPx,
          obstacleWidth,
          iconHeightPx,
        );

        if (playerRect.overlaps(obstacleRect) && !obstacle["collided"]) {
          obstacle["collided"] = true;
          dinheiro.value -= 100;
          feedbackText.value = "Você bateu em uma dívida: -R\$100";
        }
      }
      obstacles.value = obs;

      final proms = List<Map<String, dynamic>>.from(promotions.value);
      for (var promo in proms) {
        promo["x"] -= backgroundSpeed;

        if (promo["x"] < -150) {
          final newPromo = generatePromotion(screenWidth);
          promo["x"] = newPromo["x"];
          promo["y"] = newPromo["y"];
          promo["text"] = newPromo["text"];
          promo["collected"] = false;
        }

        const double promoWidth = 30;
        const double promoHeightPct = 0.08;
        double promoY = promo["y"];
        double promoTopPx = promoY * screenHeight;
        double promoHeightPx = promoHeightPct * screenHeight;
        Rect promoRect = Rect.fromLTWH(
          promo["x"],
          promoTopPx,
          promoWidth,
          promoHeightPx,
        );

        if (playerRect.overlaps(promoRect)) {
          if (promo["collected"] != true) {
            promo["collected"] = true;
            dinheiro.value += 25;
            feedbackText.value = "Você coletou uma etiqueta educativa: +R\$25";
          }
        } else {
          promo["collected"] = false;
        }
      }
      promotions.value = proms;
    });
  }

  void handleJump() {
    if (jumpCount < 2) {
      isJumping = true;
      velocity = jumpForce;
      jumpCount++;
    }
  }

  void dispose() {
    gameLoop.cancel();
    playerY.dispose();
    backgroundX1.dispose();
    backgroundX2.dispose();
    dinheiro.dispose();
    feedbackText.dispose();
    obstacles.dispose();
    promotions.dispose();
  }
}
