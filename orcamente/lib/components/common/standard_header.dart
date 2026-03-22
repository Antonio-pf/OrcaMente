import 'package:flutter/material.dart';
import 'package:orcamente/components/common/standard_card.dart';
import 'package:orcamente/components/common/standard_button.dart';

/// Standardized header component matching quiz design pattern
/// 
/// Provides consistent header styling across the app with:
/// - Optional back button
/// - Title and subtitle
/// - Optional badge (like location)
/// - Sticky behavior
/// - Shadow effects
class StandardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBackPressed;
  final Widget? badge;
  final bool showBackButton;

  const StandardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBackPressed,
    this.badge,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with back button and optional badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBackButton)
                StandardIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                ),
              
              if (badge != null) badge!,
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF616161),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Location badge component for headers
class LocationBadge extends StatelessWidget {
  final String locationName;
  final IconData icon;
  final Color iconColor;

  const LocationBadge({
    super.key,
    required this.locationName,
    this.icon = Icons.location_on,
    this.iconColor = const Color(0xFF10B981),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE8F5E9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
          const SizedBox(width: 6),
          Text(
            locationName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }
}

/// Status badge component for headers
class StatusBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const StatusBadge({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor = const Color(0xFFE8F5E9),
    this.textColor = const Color(0xFF1B5E20),
    this.iconColor = const Color(0xFF10B981),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: iconColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
