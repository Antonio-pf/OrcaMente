import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/motivation_card.dart';
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

    final docRef = _firestore.collection('piggyBanks').doc(user.uid);
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

    final docRef = _firestore.collection('piggyBanks').doc(user.uid);

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
          const SnackBar(
            content: Text('Valor guardado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar no Firestore: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um valor válido!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
    );
  }

  Widget _buildPiggyBankCard() {
    final progress = piggyBankAmount / _goalAmount;
    final cappedProgress = progress > 1 ? 1.0 : progress;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.savings, color: Colors.green, size: 20),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Meu Cofrinho",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (piggyBankAmount >= _goalAmount)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 12),
                        const SizedBox(width: 4),
                        const Text(
                          "Meta atingida!",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            
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
            
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            
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
                prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Button with improved styling
            ElevatedButton.icon(
              onPressed: _addAmountToPiggyBank,
              icon: const Icon(Icons.savings),
              label: const Text("Guardar no Cofrinho"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCircularProgress(double progress) {
    return CircularPercentIndicator(
      radius: 50.0,
      lineWidth: 10.0,
      percent: progress,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(progress * 100).toInt()}%",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text(
            "concluído",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
      progressColor: Colors.green,
      backgroundColor: Colors.green.withOpacity(0.1),
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
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            "R\$ ${piggyBankAmount.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Meta:",
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              "R\$ ${_goalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
            InkWell(
              onTap: () {
                final TextEditingController _goalController =
                    TextEditingController(text: _goalAmount.toString());
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Alterar Meta'),
                    content: TextField(
                      controller: _goalController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MoneyInputFormatter(
                          leadingSymbol: 'R\$',
                          useSymbolPadding: true,
                        ),
                      ],
                      decoration: const InputDecoration(
                        hintText: "Digite nova meta",
                        border: OutlineInputBorder(),
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
                              _goalController.text,
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
                                content: const Text('Meta alterada com sucesso!'),
                                backgroundColor: Colors.green,
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
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Editar",
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.trending_up, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Seu progresso",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
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
                        Colors.green,
                        "Economias do mês",
                        "R\$ 350,00",
                        CustomTheme.primaryColor.withOpacity(0.1),
                        CustomTheme.primaryColor.withOpacity(0.2),
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        context,
                        Icons.calendar_today,
                        Colors.purple,
                        "Dias consecutivos",
                        "7 dias",
                        CustomTheme.secondaryColor.withOpacity(0.1),
                        CustomTheme.secondaryColor.withOpacity(0.2),
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
                          Colors.green,
                          "Economias do mês",
                          "R\$ 350,00",
                          CustomTheme.primaryColor.withOpacity(0.1),
                          CustomTheme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          Icons.calendar_today,
                          Colors.purple,
                          "Dias consecutivos",
                          "7 dias",
                          CustomTheme.secondaryColor.withOpacity(0.1),
                          CustomTheme.secondaryColor.withOpacity(0.2),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Motivation card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const MotivationCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String title,
    String value,
    Color backgroundColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
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

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Suas conquistas",
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Achievements with improved styling - Responsive layout
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate how many achievements can fit per row
                final double itemWidth = 70; // Approximate width needed for each achievement
                final int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
                
                // Create rows of achievements
                return Wrap(
                  spacing: 8,
                  runSpacing: 16,
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
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: 70, // Fixed width to ensure consistent sizing
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: unlocked
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: unlocked ? Colors.green : Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow: unlocked
                      ? [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
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
                      color: Colors.green,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: unlocked ? theme.textTheme.bodySmall?.color : Colors.grey,
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: unlocked ? theme.textTheme.bodySmall?.color : Colors.grey,
              fontSize: 10,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
