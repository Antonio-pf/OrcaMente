import 'dart:math';

Map<String, dynamic> generatePromotion(double screenWidth) {
  final random = Random();
  final List<String> promoTexts = [
    "Buy 1 Get 1",
    "Flash Sale",
    "30% Off Shoes",
    "Free Shipping",
  ];

  const positioFloor = 0.1; 
  const positionAbove = 0.3;
  bool isHigh = random.nextDouble() < 0.7; // 70% de chance de aparecer no alto
  double y = isHigh
      ? (positionAbove + random.nextDouble() * 0.1) 
      : positioFloor;

  return {
    "x": screenWidth + 600,
    "y": y,
    "text": promoTexts[random.nextInt(promoTexts.length)],
  };
}
