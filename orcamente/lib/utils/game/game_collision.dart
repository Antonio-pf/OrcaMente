import 'dart:ui';

void checkCollision({
  required Rect playerRect,
  required List<Map<String, dynamic>> items,
  required double screenWidth,
  required double screenHeight,
  required double iconTopYPct,
  required double iconHeightPct,
  required double iconWidth,
  required String collisionKey,
  required double amountChange,
  required Function(String) onFeedback,
  required Function(double) onMoneyChange,
  required String feedbackMessage,
}) {
  for (var item in items) {
    item["x"] -= 3; // velocidade fixa, ou passe como parâmetro

    if (item["x"] < -150) {
      final Function resetFn = item["reset"];
      resetFn();
      item[collisionKey] = false;
    }

    double iconTopPx = iconTopYPct * screenHeight;
    double iconHeightPx = iconHeightPct * screenHeight;
    Rect itemRect = Rect.fromLTWH(
      item["x"],
      iconTopPx,
      iconWidth,
      iconHeightPx,
    );

    if (playerRect.overlaps(itemRect) && item[collisionKey] != true) {
      item[collisionKey] = true;
      onMoneyChange(amountChange);
      onFeedback(feedbackMessage);
    }
  }
}
