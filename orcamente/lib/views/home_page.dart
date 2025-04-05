import 'package:flutter/material.dart';
import 'package:orcamente/views/quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orcamente/styles/custom_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userName = "Antônio";
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Tela de Controle')),
    Center(child: Text('Tela de Educação')),
    Center(child: Text('Tela de Extrato')),
    Center(child: Text('Sobre')),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();
  }

  Future<void> _checkFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool quizAnswered = prefs.getBool('quizAnswered') ?? false;

    if (!quizAnswered) {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuizPage()),
        );
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CustomTheme.primaryColor,
                CustomTheme.primaryDark,
              ],
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
            title: Text(
              'Olá, $userName',
              style: const TextStyle(
                color: CustomTheme.neutralWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                color: CustomTheme.neutralWhite,
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark
              ? CustomTheme.neutralBlack
              : CustomTheme.primaryVeryLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          height: 70,
          backgroundColor: Colors.transparent,
          indicatorColor: isDark
              ? CustomTheme.primaryDark.withOpacity(0.2)
              : CustomTheme.primaryColor.withOpacity(0.1),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.attach_money_rounded),
              label: 'Controle',
            ),
            NavigationDestination(
              icon: Icon(Icons.school),
              label: 'Educação',
            ),
            NavigationDestination(
              icon: Icon(Icons.history),
              label: 'Extrato',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline),
              label: 'Sobre',
            ),
          ],
        ),
      ),
    );
  }
}