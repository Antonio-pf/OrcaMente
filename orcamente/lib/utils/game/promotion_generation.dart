import 'dart:math';

Map<String, dynamic> generatePromotion(double screenWidth) {
  final random = Random();

  // Lista de textos educativos sobre finanças
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

  // Gerar posição Y aleatória (altura)
  // Valores menores significam posições mais altas na tela
  double yPosition = 0.4 + (random.nextDouble() * 0.3);

  // Gerar valor aleatório para a promoção
  int value = 25 + random.nextInt(25);

  return {
    "x": screenWidth + random.nextDouble() * 300,
    "y": yPosition,
    "text": promoTexts[random.nextInt(promoTexts.length)],
    "value": value,
    "collected": false,
  };
}
