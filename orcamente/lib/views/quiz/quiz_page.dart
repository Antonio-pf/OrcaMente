import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orcamente/controllers/quiz_controller.dart';
import 'package:orcamente/controllers/home_controller.dart';
import 'package:orcamente/repositories/user_repository.dart';
import 'package:orcamente/views/quiz/quiz_result.dart';
import 'package:orcamente/styles/custom_theme.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  late final QuizController _controller;
  int? _selectedOption;
  bool _isSaving = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = QuizController(UserRepository());
    
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuiz();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadQuiz() async {
    final homeController = context.read<HomeController>();
    
    if (homeController.isLoadingQuiz) {
      int attempts = 0;
      while (homeController.isLoadingQuiz && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 200));
        attempts++;
      }
    }
    
    final preloadedQuestions = homeController.preloadedQuestions;

    if (preloadedQuestions != null && preloadedQuestions.isNotEmpty) {
      final result = await _controller.loadQuiz(preloadedQuestions: preloadedQuestions);
      
      if (!mounted) return;
      
      result.when(
        success: (_) {
          setState(() {});
          _animationController.forward();
        },
        failure: (error, exception) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: $error')),
          );
        },
      );
    } else {
      _generateQuiz();
    }
  }

  Future<void> _generateQuiz() async {
    final result = await _controller.generateQuiz();

    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() {});
        _animationController.forward();
      },
      failure: (error, exception) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $error'),
            action: SnackBarAction(
              label: 'Tentar novamente',
              onPressed: _generateQuiz,
            ),
          ),
        );
      },
    );
  }

  void _handleContinue() {
    if (_selectedOption == null) return;

    _controller.nextStep(_selectedOption!);
    
    if (_controller.isFinished) {
      _saveAndNavigate();
    } else {
      setState(() {
        _selectedOption = null;
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  Future<void> _saveAndNavigate() async {
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });

    final result = await _controller.saveAnswers();

    if (!mounted) return;

    result.when(
      success: (_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizResultPage(
              profile: _controller.getBehaviorProfile(),
              knowledge: _controller.getKnowledgeLevel(),
              aiJustification: _controller.getAIJustification(),
            ),
          ),
        );
      },
      failure: (error, exception) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $error')),
        );
        setState(() {
          _isSaving = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (_controller.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFE8F5E9),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE8F5E9),
                const Color(0xFFF1F8F4),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 2),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: CustomTheme.primaryColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.psychology_rounded,
                            size: 80,
                            color: CustomTheme.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 220,
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Color(0xFFE0E0E0),
                      valueColor: AlwaysStoppedAnimation<Color>(CustomTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '🤖 Gerando perguntas com IA...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: CustomTheme.primaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Estamos analisando sua localização\ne criando um quiz personalizado',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF616161),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Error state
    if (_controller.hasError || !_controller.hasQuestions) {
      return Scaffold(
        backgroundColor: const Color(0xFFE8F5E9),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE8F5E9),
                const Color(0xFFF1F8F4),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: Color(0xFFD32F2F),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _controller.errorMessage ?? 'Erro ao carregar quiz',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _generateQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Tentar novamente',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Quiz questions
    final currentQuestion = _controller.questions[_controller.currentStep];
    final progress = (_controller.currentStep + 1) / _controller.questions.length;
    final progressPercent = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE8F5E9),
              const Color(0xFFF1F8F4),
              const Color(0xFFE8F5E9).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Sticky Header
              Container(
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
                    // Top bar with back button and location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button - round and elegant
                        Material(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Color(0xFF424242),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        
                        // Location badge with pin icon
                        if (_controller.userLocation != null)
                          Container(
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
                                  color: const Color(0xFF2E7D32).withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: CustomTheme.primaryColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _controller.userLocation!.city,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Title - complete without cut
                    const Text(
                      'Quiz de Perfil Financeiro',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Explanatory subtitle
                    const Text(
                      'Responda algumas perguntas para personalizar sua experiência',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF616161),
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Visual progress bar with percentage
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pergunta ${_controller.currentStep + 1} de ${_controller.questions.length}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF616161),
                                    ),
                                  ),
                                  Text(
                                    '$progressPercent%',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: CustomTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 500),
                                  tween: Tween(begin: 0.0, end: progress),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return LinearProgressIndicator(
                                      value: value,
                                      minHeight: 8,
                                      backgroundColor: const Color(0xFFE0E0E0),
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        CustomTheme.primaryColor,
                                      ),
                                    );
                                  },
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
              
              // Question and options with fade animation
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question text
                        Text(
                          currentQuestion.question,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Options with improved cards
                        ...List.generate(currentQuestion.options.length, (index) {
                          final isSelected = _selectedOption == index;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  setState(() {
                                    _selectedOption = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? CustomTheme.primaryColor.withOpacity(0.05)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? CustomTheme.primaryColor
                                          : const Color(0xFFE0E0E0),
                                      width: isSelected ? 2.5 : 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? CustomTheme.primaryColor.withOpacity(0.15)
                                            : Colors.black.withOpacity(0.03),
                                        blurRadius: isSelected ? 12 : 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Animated checkmark indicator
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? CustomTheme.primaryColor
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? CustomTheme.primaryColor
                                                : const Color(0xFFBDBDBD),
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                size: 18,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 14),
                                      
                                      // Option text with better typography
                                      Expanded(
                                        child: Text(
                                          currentQuestion.options[index],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: isSelected
                                                ? const Color(0xFF1B5E20)
                                                : const Color(0xFF212121),
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        
                        const SizedBox(height: 100), // Space for fixed button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Fixed Continue button with consistent visual
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.98),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: ElevatedButton(
              onPressed: _selectedOption != null && !_isSaving ? _handleContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFBDBDBD),
                disabledForegroundColor: const Color(0xFF757575),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: _selectedOption != null ? 4 : 0,
                shadowColor: const Color(0xFF2E7D32).withOpacity(0.3),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _controller.isLastStep ? 'Finalizar' : 'Continuar',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
