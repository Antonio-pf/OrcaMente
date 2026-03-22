import 'package:flutter/material.dart';
import 'package:orcamente/styles/custom_theme.dart';

/// Standardized button component matching quiz design pattern
/// 
/// Provides consistent button styling across the app with:
/// - Rounded corners (16px)
/// - Proper padding and sizing
/// - Loading states
/// - Disabled states
/// - Icon support
class StandardButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final Color? shadowColor;

  const StandardButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderRadius = 16,
    this.padding,
    this.elevation = 4,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = backgroundColor ?? CustomTheme.primaryColor;
    final defaultForegroundColor = foregroundColor ?? Colors.white;

    Widget buttonChild;

    if (isLoading) {
      buttonChild = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, size: 20),
        ],
      );
    } else {
      buttonChild = Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed != null && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: defaultBackgroundColor,
        foregroundColor: defaultForegroundColor,
        disabledBackgroundColor: disabledBackgroundColor ?? const Color(0xFFBDBDBD),
        disabledForegroundColor: disabledForegroundColor ?? const Color(0xFF757575),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: onPressed != null && !isLoading ? elevation : 0,
        shadowColor: shadowColor ?? defaultBackgroundColor.withOpacity(0.3),
      ),
      child: buttonChild,
    );
  }
}

/// Standardized icon button for back navigation and similar actions
class StandardIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final Color? borderColor;

  const StandardIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor ?? const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: iconColor ?? const Color(0xFF424242),
            size: 20,
          ),
        ),
      ),
    );
  }
}
