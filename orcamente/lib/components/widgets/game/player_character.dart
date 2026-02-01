import 'package:flutter/material.dart';

class PlayerCharacter extends StatelessWidget {
  final AnimationController animationController;
  final bool isJumping;
  final bool hasShield;
  final bool hasSpeedBoost;

  const PlayerCharacter({
    super.key,
    required this.animationController,
    required this.isJumping,
    this.hasShield = false,
    this.hasSpeedBoost = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Escudo protetor
            if (hasShield)
              Container(
                width: 70,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.cyan.withOpacity(0.6),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

            // Aura de velocidade
            if (hasSpeedBoost)
              Container(
                width: 65,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.amber.withOpacity(0.3),
                      Colors.orange.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

            // Personagem
            Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.deepPurple[700],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: isJumping ? 8 : 5,
                    offset: Offset(2, isJumping ? 4 : 2),
                  ),
                  if (hasSpeedBoost)
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                ],
              ),
              child: Stack(
                children: [
                  // Corpo com gradiente animado
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:
                              hasSpeedBoost
                                  ? [
                                    Colors.amber[400]!,
                                    Colors.deepPurple[600]!,
                                  ]
                                  : [
                                    Colors.deepPurple[400]!,
                                    Colors.deepPurple[800]!,
                                  ],
                        ),
                      ),
                    ),
                  ),

                  // Olhos expressivos
                  Positioned(
                    top: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Olho esquerdo
                        Container(
                          width: isJumping ? 6 : 8,
                          height: isJumping ? 10 : 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Olho direito
                        Container(
                          width: isJumping ? 6 : 8,
                          height: isJumping ? 10 : 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Boca expressiva
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: isJumping ? 12 : 15,
                        height: isJumping ? 10 : 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            isJumping ? 6 : 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child:
                            isJumping
                                ? Center(
                                  child: Container(
                                    width: 8,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.pink[300],
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                )
                                : null,
                      ),
                    ),
                  ),

                  // Braços animados
                  Positioned(
                    left: -5,
                    top: 20,
                    child: Transform.rotate(
                      angle: isJumping ? -0.8 : 0.4 * animationController.value,
                      child: Container(
                        width: 16,
                        height: 6,
                        decoration: BoxDecoration(
                          color:
                              hasSpeedBoost
                                  ? Colors.amber[600]
                                  : Colors.deepPurple[600],
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -5,
                    top: 20,
                    child: Transform.rotate(
                      angle: isJumping ? 0.8 : -0.4 * animationController.value,
                      child: Container(
                        width: 16,
                        height: 6,
                        decoration: BoxDecoration(
                          color:
                              hasSpeedBoost
                                  ? Colors.amber[600]
                                  : Colors.deepPurple[600],
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Pernas animadas
                  Positioned(
                    left: 10,
                    bottom: -5,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        isJumping ? 8 : 3 * animationController.value,
                      ),
                      child: Container(
                        width: 6,
                        height: isJumping ? 12 : 15,
                        decoration: BoxDecoration(
                          color:
                              hasSpeedBoost
                                  ? Colors.amber[700]
                                  : Colors.deepPurple[700],
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: -5,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        isJumping ? 8 : -3 * animationController.value,
                      ),
                      child: Container(
                        width: 6,
                        height: isJumping ? 12 : 15,
                        decoration: BoxDecoration(
                          color:
                              hasSpeedBoost
                                  ? Colors.amber[700]
                                  : Colors.deepPurple[700],
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Partículas de corrida
                  if (!isJumping && hasSpeedBoost)
                    Positioned(
                      right: 50,
                      bottom: 5,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: EdgeInsets.only(left: index * 8.0),
                            child: Opacity(
                              opacity: 0.6 - (index * 0.2),
                              child: Container(
                                width: 4 - index.toDouble(),
                                height: 4 - index.toDouble(),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
