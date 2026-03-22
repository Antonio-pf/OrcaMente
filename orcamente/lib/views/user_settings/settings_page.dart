import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orcamente/controllers/theme_controller.dart';
import 'package:orcamente/components/common/standard_card.dart';
import 'package:orcamente/styles/custom_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.themeMode == ThemeMode.dark;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? CustomTheme.neutralWhite : CustomTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 24),
          
          // Appearance Section
          StandardCard(
            backgroundColor: isDark 
                ? CustomTheme.neutralBlack.withOpacity(0.5)
                : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconBadge(
                      icon: Icons.palette_outlined,
                      iconColor: CustomTheme.primaryColor,
                      backgroundColor: CustomTheme.primaryColor.withOpacity(0.1),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Aparência',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? CustomTheme.neutralWhite : CustomTheme.neutralBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: isDark 
                        ? CustomTheme.neutralBlack.withOpacity(0.3)
                        : CustomTheme.neutralLightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: CustomTheme.primaryColor,
                    ),
                    title: Text(
                      'Modo Escuro',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? CustomTheme.neutralWhite : CustomTheme.neutralBlack,
                      ),
                    ),
                    subtitle: Text(
                      isDarkMode ? 'Ativado' : 'Desativado',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark 
                            ? CustomTheme.neutralLightGray
                            : CustomTheme.neutralDarkGray,
                      ),
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        themeController.toggleTheme(value);
                      },
                      activeColor: CustomTheme.primaryColor,
                      activeTrackColor: CustomTheme.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Notifications Section
          StandardCard(
            backgroundColor: isDark 
                ? CustomTheme.neutralBlack.withOpacity(0.5)
                : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconBadge(
                      icon: Icons.notifications_outlined,
                      iconColor: CustomTheme.secondaryColor,
                      backgroundColor: CustomTheme.secondaryColor.withOpacity(0.1),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Notificações',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? CustomTheme.neutralWhite : CustomTheme.neutralBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSettingItem(
                  context: context,
                  icon: Icons.savings_outlined,
                  title: 'Lembretes de Poupança',
                  subtitle: 'Receba lembretes para poupar',
                  isDark: isDark,
                  value: true,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 8),
                _buildSettingItem(
                  context: context,
                  icon: Icons.trending_up,
                  title: 'Metas Financeiras',
                  subtitle: 'Notificações sobre suas metas',
                  isDark: isDark,
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Privacy Section
          StandardCard(
            backgroundColor: isDark 
                ? CustomTheme.neutralBlack.withOpacity(0.5)
                : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconBadge(
                      icon: Icons.security_outlined,
                      iconColor: CustomTheme.successColor,
                      backgroundColor: CustomTheme.successColor.withOpacity(0.1),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Privacidade',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? CustomTheme.neutralWhite : CustomTheme.neutralBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.lock_outline,
                  title: 'Alterar Senha',
                  isDark: isDark,
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _buildNavigationItem(
                  context: context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de Privacidade',
                  isDark: isDark,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? CustomTheme.neutralBlack.withOpacity(0.3)
            : CustomTheme.neutralLightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: CustomTheme.primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? CustomTheme.neutralWhite : CustomTheme.neutralBlack,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDark 
                ? CustomTheme.neutralLightGray
                : CustomTheme.neutralDarkGray,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: CustomTheme.primaryColor,
          activeTrackColor: CustomTheme.primaryLight,
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? CustomTheme.neutralBlack.withOpacity(0.3)
            : CustomTheme.neutralLightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: CustomTheme.primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? CustomTheme.neutralWhite : CustomTheme.neutralBlack,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark 
              ? CustomTheme.neutralLightGray
              : CustomTheme.neutralDarkGray,
        ),
        onTap: onTap,
      ),
    );
  }
}
