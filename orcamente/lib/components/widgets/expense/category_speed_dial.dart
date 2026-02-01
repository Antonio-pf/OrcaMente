import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:orcamente/styles/custom_theme.dart';

class CategorySpeedDial extends StatelessWidget {
  final Function(String) onSelectCategory;

  const CategorySpeedDial({super.key, required this.onSelectCategory});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: CustomTheme.primaryColor,
      overlayOpacity: 0.2,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.home),
          label: 'Essencial',
          backgroundColor: CustomTheme.primaryLight,
          onTap: () => onSelectCategory('essencial'),
        ),
        SpeedDialChild(
          child: const Icon(Icons.sports_esports),
          label: 'Lazer',
          backgroundColor: CustomTheme.primaryLight,
          onTap: () => onSelectCategory('lazer'),
        ),
        SpeedDialChild(
          child: const Icon(Icons.all_inbox),
          label: 'Outros',
          backgroundColor: CustomTheme.primaryLight,
          onTap: () => onSelectCategory('outros'),
        ),
      ],
    );
  }
}
