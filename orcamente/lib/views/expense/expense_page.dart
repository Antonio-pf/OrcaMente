import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/components/widgets/expense/summary_card.dart';
import 'package:orcamente/components/widgets/shimmer_list.dart';
import 'package:orcamente/controllers/expense_controller.dart';
import 'package:orcamente/styles/custom_theme.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageViewState();
}

class _ExpensePageViewState extends State<ExpensePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ExpenseController _controller = ExpenseController();

  final List<String> _categories = ['essencial', 'lazer', 'outros'];
  final Map<String, String> _categoryLabels = {
    'essencial': 'Essenciais',
    'lazer': 'Lazer',
    'outros': 'Outros',
  };
  final Map<String, Color> _categoryColors = {
    'essencial': Colors.green,
    'lazer': Colors.purple,
    'outros': Colors.orange,
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      await _controller.fetchExpenses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar despesas: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  double _getTotalExpense(String category) {
    final expenses = _controller.getExpensesByCategory(category);
    return expenses.fold(0.0, (sum, e) => sum + e.value);
  }

  double _getTotalAllExpenses() {
    return _categories.fold(0.0, (sum, c) => sum + _getTotalExpense(c));
  }

  double _getCategoryPercentage(String category) {
    final total = _getTotalAllExpenses();
    if (total <= 0) return 0;
    return (_getTotalExpense(category) / total) * 100;
  }

  void _openAddExpenseModal(String category) {
    final descController = TextEditingController();
    final valueController = TextEditingController();

    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Novo Gasto - ${_categoryLabels[category]}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: descController,
                      hintText: 'Descrição',
                      icon: Icons.edit,
                      onChanged: (_) {
                        if (errorText != null) setModalState(() => errorText = null);
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: valueController,
                      hintText: 'Valor',
                      icon: Icons.attach_money,
                      onChanged: (_) {
                        if (errorText != null) setModalState(() => errorText = null);
                      },
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final desc = descController.text.trim();
                          final value = double.tryParse(valueController.text.replaceAll(',', '.')) ?? 0;

                          if (desc.isEmpty || value <= 0) {
                            setModalState(() {
                              errorText = 'Preencha todos os campos corretamente.';
                            });
                            return;
                          }

                          try {
                            await _controller.addExpense(desc, value, category);
                            Navigator.pop(context);
                            setState(() {}); // Atualiza lista
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Despesa adicionada com sucesso!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } catch (e) {
                            setModalState(() {
                              errorText = 'Erro ao salvar despesa: $e';
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Salvar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getCardColor(String category) {
    switch (category) {
      case 'essencial':
        return const Color.fromARGB(255, 220, 247, 234);
      case 'lazer':
        return const Color.fromARGB(255, 237, 220, 247);
      case 'outros':
        return const Color.fromARGB(255, 255, 236, 217);
      default:
        return Colors.grey[100]!;
    }
  }

  Widget _buildExpenseList(String category) {
    if (_isLoading) {
      return const ShimmerPlaceholderList(itemCount: 2);
    }

    final expenses = _controller.getExpensesByCategory(category);

    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum gasto registrado',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return Dismissible(
          key: Key(expense.id),
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            await _controller.removeExpense(expense.id);
            setState(() {});

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.delete_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Despesa removida')),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(10),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'DESFAZER',
                  textColor: Colors.white,
                  onPressed: () async {
                    await _controller.undoRemoveExpense();
                    setState(() {});
                  },
                ),
              ),
            );
          },
          child: Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            color: _getCardColor(category),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                expense.description,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Text(
                '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              trailing: Text(
                'R\$ ${expense.value.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard() {
    return SummaryCard(
      totalAmount: _getTotalAllExpenses(),
      categories: _categories,
      categoryLabels: _categoryLabels,
      categoryColors: _categoryColors,
      getTotalExpense: _getTotalExpense,
      getCategoryPercentage: _getCategoryPercentage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSummaryCard(),
          TabBar(
            controller: _tabController,
            tabs: _categories.map((c) => Tab(text: _categoryLabels[c])).toList(),
            labelColor: Colors.green[700],
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Colors.green,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((c) => _buildExpenseList(c)).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final currentIndex = _tabController.index;
          _openAddExpenseModal(_categories[currentIndex]);
        },
        backgroundColor: CustomTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
