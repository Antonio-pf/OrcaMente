import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/motivation_card.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PiggyBankPage extends StatefulWidget {
  const PiggyBankPage({super.key});

  @override
  State<PiggyBankPage> createState() => _PiggyBankPageState();
}

class _PiggyBankPageState extends State<PiggyBankPage> {
  double piggyBankAmount = 0.0;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPiggyBankAmount();
  }

  Future<void> _loadPiggyBankAmount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      piggyBankAmount = prefs.getDouble('piggy_bank_amount') ?? 0.0;
    });
  }

  Future<void> _savePiggyBankAmount(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('piggy_bank_amount', amount);
  }

  void _addAmountToPiggyBank() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      setState(() {
        piggyBankAmount += amount;
        _savePiggyBankAmount(piggyBankAmount);
        _amountController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Valor guardado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.savings, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Meu Cofrinho",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Saldo atual", style: TextStyle(fontSize: 14)),
            Text(
              "R\$ ${piggyBankAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text("Meta: R\$ 500,00", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: piggyBankAmount / 500.0 > 1 ? 1 : piggyBankAmount / 500.0,
              color: Colors.green,
              backgroundColor: const Color(0xffe0e0e0),
            ),
            const SizedBox(height: 8),
            if (piggyBankAmount >= 500)
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 4),
                  Text("Meta atingida!", style: TextStyle(color: Colors.green)),
                ],
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Quanto deseja guardar?",
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _addAmountToPiggyBank,
              icon: const Icon(Icons.savings),
              label: const Text("Guardar no Cofrinho"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: CustomTheme.cardColor(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Seu progresso",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CustomTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Economias do mês",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text("R\$ 350,00",
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CustomTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Dias consecutivos",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text("7 dias",
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
             const MotivationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard(BuildContext context, double amount) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  color: theme.cardColor,
  child: Padding(
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Suas conquistas",
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildAchievementIcon(context, Icons.savings, "Primeiro", "depósito", amount > 0),
            _buildAchievementIcon(context, Icons.emoji_events, "Meta", "atingida", amount >= 500),
            _buildAchievementIcon(context, Icons.calendar_month, "30 dias", "seguidos", false),
            _buildAchievementIcon(context, Icons.monetization_on, "R\$ 5.000", "economizados", amount >= 5000),
          ],
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

  final backgroundColor = unlocked
      ? CustomTheme.primaryColor
      : isDark
          ? CustomTheme.neutralDarkGray
          : CustomTheme.neutralLightGray;

  final iconColor = unlocked ? Colors.white : theme.colorScheme.onBackground.withOpacity(0.6);
  final textColor = unlocked
      ? theme.textTheme.bodySmall?.color
      : theme.textTheme.bodySmall?.color?.withOpacity(0.5);

  return Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: backgroundColor,
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor,
          ),
        ),
      ],
    ),
  );
}

}
