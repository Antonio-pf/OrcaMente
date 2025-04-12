import 'package:flutter/material.dart';

class PlayerCharacter extends StatelessWidget {
  final AnimationController animationController;
  final bool isJumping;

  const PlayerCharacter({
    super.key,
    required this.animationController,
    required this.isJumping,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.deepPurple[700],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Corpo
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepPurple[400]!,
                        Colors.deepPurple[800]!,
                      ],
                    ),
                  ),
                ),
              ),
              
              // Rosto
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: isJumping ? 4 : 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 8,
                      height: isJumping ? 4 : 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Boca
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 15,
                    height: isJumping ? 8 : 3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              
              // Braços
              Positioned(
                left: -5,
                top: 20,
                child: Transform.rotate(
                  angle: isJumping ? -0.5 : 0.3 * animationController.value,
                  child: Container(
                    width: 15,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[600],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -5,
                top: 20,
                child: Transform.rotate(
                  angle: isJumping ? 0.5 : -0.3 * animationController.value,
                  child: Container(
                    width: 15,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[600],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              
              // Pernas
              Positioned(
                left: 10,
                bottom: -5,
                child: Transform.translate(
                  offset: Offset(0, isJumping ? 5 : 2 * animationController.value),
                  child: Container(
                    width: 5,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[600],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: -5,
                child: Transform.translate(
                  offset: Offset(0, isJumping ? 5 : -2 * animationController.value),
                  child: Container(
                    width: 5,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[600],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
