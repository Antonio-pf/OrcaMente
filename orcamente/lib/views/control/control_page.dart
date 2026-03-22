import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/motivation_card.dart';
import 'package:orcamente/components/common/gradient_background.dart';
import 'package:orcamente/components/common/standard_card.dart';
import 'package:orcamente/components/common/standard_button.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PiggyBankPage extends StatefulWidget {
  const PiggyBankPage({super.key});

  @override
  State<PiggyBankPage> createState() => _PiggyBankPageState();
}

class _PiggyBankPageState extends State<PiggyBankPage> {
  double piggyBankAmount = 0.0;
  double _goalAmount = 500.0;
  final TextEditingController _amountController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadPiggyBankAmount();
  }

  Future<void> _loadPiggyBankAmount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('piggy_banks').doc(user.uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        piggyBankAmount = (data?['amount'] ?? 0).toDouble();
      });
    } else {
      setState(() {
        piggyBankAmount = 0.0;
      });
    }
  }

  Future<void> _savePiggyBankAmount(double amount) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final docRef = _firestore.collection('piggy_banks').doc(user.uid);

    await docRef.set({
      'amount': amount,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void _addAmountToPiggyBank() async {
    final amountText = _amountController.text;
    final amount = double.tryParse(
      toNumericString(amountText, allowPeriod: true),
    );

    if (amount != null && amount > 0) {
      setState(() {
        piggyBankAmount += amount;
      });

      try {
        await _savePiggyBankAmount(piggyBankAmount);
        _amountController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Valor guardado com sucesso!'),
              ],
            ),
            backgroundColor: CustomTheme.primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Erro ao salvar: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Informe um valor válido!'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildPiggyBankCard(),
              const SizedBox(height: 16),
              _buildProgressCard(context),
              const SizedBox(height: 16),
              _buildAchievementsCard(context, piggyBankAmount),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPiggyBankCard() {
    final progress = piggyBankAmount / _goalAmount;
    final cappedProgress = progress > 1 ? 1.0 : progress;

    return StandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and badge
          Row(
            children: [
              const IconBadge(
                icon: Icons.savings,
                iconColor: CustomTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Meu Cofrinho",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (piggyBankAmount >= _goalAmount)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: CustomTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: CustomTheme.primaryColor,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Meta atingida!",
                        style: TextStyle(
                          color: CustomTheme.primaryDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Progress and amount info - Responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              // For very small screens, stack the progress indicator and amount info
              if (constraints.maxWidth < 300) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCircularProgress(cappedProgress),
                    const SizedBox(height: 16),
                    _buildAmountInfo(),
                  ],
                );
              } else {
                // For larger screens, place them side by side
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCircularProgress(cappedProgress),
                    const SizedBox(width: 16),
                    Expanded(child: _buildAmountInfo()),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 24),
          Divider(color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 20),

          // Input field with improved styling
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              MoneyInputFormatter(
                leadingSymbol: 'R\$',
                useSymbolPadding: true,
              ),
            ],
            decoration: InputDecoration(
              hintText: "Quanto deseja guardar?",
              hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
              prefixIcon: const Icon(Icons.attach_money, color: CustomTheme.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: CustomTheme.primaryColor, width: 2.5),
              ),
              filled: true,
              fillColor: CustomTheme.primaryColor.withOpacity(0.03),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Button with standardized styling
          SizedBox(
            width: double.infinity,
            child: StandardButton(
              text: "Guardar no Cofrinho",
              icon: Icons.savings,
              onPressed: _addAmountToPiggyBank,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(double progress) {
    return CircularPercentIndicator(
      radius: 55.0,
      lineWidth: 12.0,
      percent: progress,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(progress * 100).toInt()}%",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF1B5E20),
            ),
          ),
          const Text(
            "concluído",
            style: TextStyle(fontSize: 11, color: Color(0xFF757575)),
          ),
        ],
      ),
      progressColor: CustomTheme.primaryColor,
      backgroundColor: CustomTheme.primaryColor.withOpacity(0.15),
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 1000,
    );
  }

  Widget _buildAmountInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Saldo atual",
          style: TextStyle(fontSize: 14, color: Color(0xFF757575), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            "R\$ ${piggyBankAmount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Meta:",
              style: TextStyle(color: Color(0xFF757575), fontSize: 14),
            ),
            Text(
              "R\$ ${_goalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
            InkWell(
              onTap: () {
                final TextEditingController goalController =
                    TextEditingController(text: _goalAmount.toString());
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          'Alterar Meta',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: TextField(
                          controller: goalController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            MoneyInputFormatter(
                              leadingSymbol: 'R\$',
                              useSymbolPadding: true,
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: "Digite nova meta",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: CustomTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final newGoal = double.tryParse(
                                toNumericString(
                                  goalController.text,
                                  allowPeriod: true,
                                ),
                              );

                              if (newGoal != null && newGoal > 0) {
                                setState(() {
                                  _goalAmount = newGoal;
                                });
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text('Meta alterada com sucesso!'),
                                      ],
                                    ),
                                    backgroundColor: CustomTheme.primaryColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomTheme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Salvar'),
                          ),
                        ],
                      ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CustomTheme.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Text(
                  "Editar",
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return StandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.trending_up,
                iconColor: CustomTheme.secondaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Seu progresso",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: const Color(0xFF1B5E20),
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats cards with improved styling - Responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              // For very small screens, stack the stat cards
              if (constraints.maxWidth < 300) {
                return Column(
                  children: [
                    _buildStatCard(
                      context,
                      Icons.savings_outlined,
                      CustomTheme.primaryColor,
                      "Economias do mês",
                      "R\$ 350,00",
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      context,
                      Icons.calendar_today,
                      CustomTheme.secondaryColor,
                      "Dias consecutivos",
                      "7 dias",
                    ),
                  ],
                );
              } else {
                // For larger screens, place them side by side
                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        Icons.savings_outlined,
                        CustomTheme.primaryColor,
                        "Economias do mês",
                        "R\$ 350,00",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        Icons.calendar_today,
                        CustomTheme.secondaryColor,
                        "Dias consecutivos",
                        "7 dias",
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 20),

          // Motivation card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const MotivationCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: const Color(0xFF1B5E20),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard(BuildContext context, double amount) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return StandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.emoji_events,
                iconColor: Colors.amber,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Suas conquistas",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: const Color(0xFF1B5E20),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Achievements with improved styling - Responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 12,
                runSpacing: 20,
                alignment: WrapAlignment.spaceAround,
                children: [
                  _buildAchievementIcon(
                    context,
                    Icons.savings,
                    "Primeiro",
                    "depósito",
                    amount > 0,
                  ),
                  _buildAchievementIcon(
                    context,
                    Icons.emoji_events,
                    "Meta",
                    "atingida",
                    amount >= 500,
                  ),
                  _buildAchievementIcon(
                    context,
                    Icons.calendar_month,
                    "30 dias",
                    "seguidos",
                    false,
                  ),
                  _buildAchievementIcon(
                    context,
                    Icons.monetization_on,
                    "R\$ 5.000",
                    "economizados",
                    amount >= 5000,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementIcon(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool unlocked,
  ) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color:
                      unlocked
                          ? CustomTheme.primaryColor.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: unlocked ? CustomTheme.primaryColor : Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow:
                      unlocked
                          ? [
                              BoxShadow(
                                color: CustomTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              if (unlocked)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: CustomTheme.primaryColor,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: unlocked ? const Color(0xFF1B5E20) : Colors.grey,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: unlocked ? const Color(0xFF616161) : Colors.grey,
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
