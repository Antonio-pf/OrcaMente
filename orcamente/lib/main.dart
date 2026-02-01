import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';

import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/controllers/theme_controller.dart';
import 'package:orcamente/controllers/home_controller.dart';
import 'package:orcamente/controllers/expense_controller.dart';
import 'package:orcamente/controllers/piggy_controller.dart';
import 'package:orcamente/controllers/quiz_controller.dart';

import 'package:orcamente/services/auth_service.dart';
import 'package:orcamente/services/firestore_service.dart';

import 'package:orcamente/repositories/user_repository.dart';
import 'package:orcamente/repositories/expense_repository.dart';
import 'package:orcamente/repositories/piggy_bank_repository.dart';

import 'package:orcamente/views/about_page.dart';
import 'package:orcamente/views/auth/forget_password.dart';
import 'package:orcamente/views/home_page.dart';
import 'package:orcamente/views/auth/login_page.dart';
import 'package:orcamente/views/auth/register_page.dart';

// GetIt instance for dependency injection
final getIt = GetIt.instance;

/// Setup all dependencies using GetIt
void setupDependencies() {
  // Register Services (Singletons)
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());

  // Register Repositories (Singletons with dependencies)
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(firestoreService: getIt<FirestoreService>()),
  );

  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepository(
      firestoreService: getIt<FirestoreService>(),
      authService: getIt<AuthService>(),
    ),
  );

  getIt.registerLazySingleton<PiggyBankRepository>(
    () => PiggyBankRepository(
      firestoreService: getIt<FirestoreService>(),
      authService: getIt<AuthService>(),
    ),
  );

  // Register Controllers that don't manage TextEditingControllers (Factories)
  getIt.registerFactory<HomeController>(
    () => HomeController(getIt<UserRepository>()),
  );

  getIt.registerFactory<ExpenseController>(
    () => ExpenseController(getIt<ExpenseRepository>()),
  );

  getIt.registerFactory<PiggyBankController>(
    () => PiggyBankController(getIt<PiggyBankRepository>()),
  );

  getIt.registerFactory<QuizController>(
    () => QuizController(getIt<UserRepository>()),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup dependency injection
  setupDependencies();

  runApp(
    DevicePreview(enabled: true, builder: (context) => const AppProviders()),
  );
}

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme controller (no dependencies)
        ChangeNotifierProvider(create: (_) => ThemeController()),

        // Controllers with dependencies injected from GetIt
        // Note: Auth controllers (Login, Register, ForgotPassword) are created
        // in their respective pages because they manage TextEditingControllers
        ChangeNotifierProvider(create: (_) => getIt<HomeController>()),
        ChangeNotifierProvider(create: (_) => getIt<ExpenseController>()),
        ChangeNotifierProvider(create: (_) => getIt<PiggyBankController>()),
        ChangeNotifierProvider(create: (_) => getIt<QuizController>()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      title: 'OrçaMente',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: themeController.themeMode,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      home: LoginPage(),
      routes: {
        '/register': (context) => const CadastroPage(),
        '/forget-password': (context) => ForgotPasswordPage(),
        '/about': (context) => const AboutPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
