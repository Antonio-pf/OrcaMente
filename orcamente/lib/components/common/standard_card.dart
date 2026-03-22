import 'package:flutter/material.dart';

/// Standardized card component matching quiz design pattern
/// 
/// Provides consistent card styling across the app with:
/// - Rounded corners (16px)
/// - Subtle shadows
/// - Optional gradient backgrounds
/// - Responsive padding
class StandardCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final List<BoxShadow>? shadows;
  final Border? border;
  final Gradient? gradient;

  const StandardCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.borderRadius = 16,
    this.shadows,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final defaultShadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ];

    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? Colors.white.withOpacity(0.95)) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: shadows ?? defaultShadows,
      ),
      child: child,
    );
  }
}

/// Icon badge component for card headers
class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final double size;

  const IconBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: size,
      ),
    );
  }
}
