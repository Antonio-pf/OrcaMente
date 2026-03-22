import 'package:flutter/material.dart';

/// Gradient background widget matching quiz design pattern
/// 
/// Provides consistent gradient backgrounds across the app
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColors = [
      const Color(0xFFE8F5E9),
      const Color(0xFFF1F8F4),
      const Color(0xFFE8F5E9).withOpacity(0.8),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? defaultColors,
        ),
      ),
      child: child,
    );
  }
}
