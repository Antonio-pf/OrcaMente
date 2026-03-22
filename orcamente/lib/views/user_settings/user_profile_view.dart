import 'package:flutter/material.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/auth/login_page.dart';
import 'package:orcamente/components/common/standard_card.dart';
import 'package:orcamente/components/common/standard_button.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          StandardCard(
            backgroundColor: isDark 
                ? CustomTheme.neutralBlack.withOpacity(0.5)
                : Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            CustomTheme.primaryColor,
                            CustomTheme.secondaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: CustomTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuário',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark 
                                  ? CustomTheme.neutralWhite
                                  : CustomTheme.neutralBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'usuario@email.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark 
                                  ? CustomTheme.neutralLightGray
                                  : CustomTheme.neutralDarkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Progress Section
          Text(
            'Progresso do Usuário',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark 
                  ? CustomTheme.neutralWhite
                  : CustomTheme.neutralBlack,
            ),
          ),
          
          const SizedBox(height: 16),
          
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
                      icon: Icons.school_outlined,
                      iconColor: CustomTheme.primaryColor,
                      backgroundColor: CustomTheme.primaryColor.withOpacity(0.1),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Módulos Completados',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark 
                            ? CustomTheme.neutralWhite
                            : CustomTheme.neutralBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: isDark 
                        ? CustomTheme.neutralBlack.withOpacity(0.3)
                        : CustomTheme.neutralLightGray,
                    color: CustomTheme.primaryColor,
                    minHeight: 10,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "60% concluído",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark 
                            ? CustomTheme.neutralLightGray
                            : CustomTheme.neutralDarkGray,
                      ),
                    ),
                    Text(
                      "6 de 10 módulos",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CustomTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Stats Section
          Text(
            'Estatísticas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark 
                  ? CustomTheme.neutralWhite
                  : CustomTheme.neutralBlack,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: StandardCard(
                  backgroundColor: isDark 
                      ? CustomTheme.neutralBlack.withOpacity(0.5)
                      : Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      IconBadge(
                        icon: Icons.attach_money,
                        iconColor: CustomTheme.successColor,
                        backgroundColor: CustomTheme.successColor.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'R\$ 1.250',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark 
                              ? CustomTheme.neutralWhite
                              : CustomTheme.neutralBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Economia Total',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark 
                              ? CustomTheme.neutralLightGray
                              : CustomTheme.neutralDarkGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StandardCard(
                  backgroundColor: isDark 
                      ? CustomTheme.neutralBlack.withOpacity(0.5)
                      : Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      IconBadge(
                        icon: Icons.emoji_events_outlined,
                        iconColor: CustomTheme.secondaryColor,
                        backgroundColor: CustomTheme.secondaryColor.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '15',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark 
                              ? CustomTheme.neutralWhite
                              : CustomTheme.neutralBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Conquistas',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark 
                              ? CustomTheme.neutralLightGray
                              : CustomTheme.neutralDarkGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Logout Button
          StandardButton(
            text: "Sair da Conta",
            icon: Icons.logout,
            backgroundColor: CustomTheme.errorColor,
            foregroundColor: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar saída'),
                  content: const Text('Tem certeza que deseja sair da sua conta?'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: CustomTheme.neutralDarkGray),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Sair',
                        style: TextStyle(color: CustomTheme.errorColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
