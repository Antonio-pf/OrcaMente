import 'package:flutter/material.dart';
import 'package:orcamente/styles/custom_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final String userName;
  final VoidCallback onAvatarTap;
  final bool showSettings;

  const CustomAppBar({
    super.key,
    required this.selectedIndex,
    required this.userName,
    required this.onAvatarTap,
    required this.showSettings,
  });

  @override
  Widget build(BuildContext context) {
    final String title = selectedIndex == 1 ? 'Para você' : 'Olá, $userName';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomTheme.primaryColor, CustomTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: CustomTheme.neutralWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          AnimatedOpacity(
            opacity: showSettings ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400), 
            curve: Curves.easeInOutCubic,
            child: Visibility(
              visible: showSettings,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configurações futuras...')),
                  );
                },
                icon: const Icon(Icons.settings, color: CustomTheme.neutralWhite),
              ),
            ),
          ),

            const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/36?img=50',
                    fit: BoxFit.cover,
                    width: 36,
                    height: 36,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
