import 'package:flutter/material.dart';
import 'package:orcamente/styles/custom_theme.dart';

class CustomCourseCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CustomCourseCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isDark ? CustomTheme.neutralDarkGray : Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isDark
                    ? CustomTheme.primaryColor.withOpacity(0.2)
                    : CustomTheme.primaryVeryLight,
                child: Icon(
                  icon,
                  color: isDark ? Colors.white : CustomTheme.primaryDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white
                        : CustomTheme.neutralBlack,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
