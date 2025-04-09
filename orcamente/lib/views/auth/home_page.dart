import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_app_bar.dart';
import 'package:orcamente/views/quiz/quiz_page.dart';
import 'package:orcamente/views/course/course_page.dart';
import 'package:orcamente/views/user_settings/user_profile_view.dart';
import 'package:orcamente/views/user_settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:provider/provider.dart';
import 'package:orcamente/controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _showUserPanel = false;
  bool _showSettingsPage = false;

  final List<Widget> _pages = [
    Center(child: Text('Tela de Controle')),
    const CourseListPage(),
    Center(child: Text('Tela de Extrato')),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstLogin();

    // update no title do app bar uma vez
    Future.microtask(() {
      context.read<HomeController>().initTitleChange();
    });
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
      _showUserPanel = false;
      _showSettingsPage = false;
    });

    if (index == 0) {
      context.read<HomeController>().initTitleChange();
    }
  }

  void _onAvatarTap() {
    setState(() {
      _showUserPanel = !_showUserPanel;
      _showSettingsPage = false;
    });
  }

  void _onSettingsTap() {
    setState(() {
      _showSettingsPage = true;
      _showUserPanel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = context.watch<HomeController>();
    final String title = _selectedIndex == 1 ? 'Para você' : controller.appBarTitle;

    return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: _selectedIndex,
        title: title,
        showSettings: _showUserPanel,
        onAvatarTap: _onAvatarTap,
        onSettingsTap: _onSettingsTap,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showSettingsPage
            ? const SettingsPage()
            : _showUserPanel
                ? const UserProfileView()
                : _pages[_selectedIndex],
      ),
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
          ],
        ),
      ),
    );
  }
}
