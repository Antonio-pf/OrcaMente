import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/components/widgets/expense/category_speed_dial.dart';
import 'package:orcamente/controllers/expense_controller.dart';
import 'package:orcamente/styles/custom_theme.dart';
import 'package:orcamente/views/shimmer_list.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageViewState();
}

class _ExpensePageViewState extends State<ExpensePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ExpenseController _controller = ExpenseController();

  final List<String> _categories = ['essencial', 'lazer', 'outros'];
  final Map<String, String> _categoryLabels = {
    'essencial': 'Essenciais',
    'lazer': 'Lazer',
    'outros': 'Outros',
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _openAddExpenseModal(String category) {
    final TextEditingController descController = TextEditingController();
    final TextEditingController valueController = TextEditingController();

    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        if (errorText != null) {
                          setState(() => errorText = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: valueController,
                      hintText: 'Valor',
                      icon: Icons.attach_money,
                      onChanged: (_) {
                        if (errorText != null) {
                          setState(() => errorText = null);
                        }
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
                        onPressed: () {
                          final desc = descController.text;
                          final value =
                              double.tryParse(valueController.text) ?? 0;

                          if (desc.isEmpty || value <= 0) {
                            setState(() {
                              errorText =
                                  'Preencha todos os campos corretamente.';
                            });
                          } else {
                            _controller.addExpense(desc, value, category);
                            Navigator.pop(
                              modalContext,
                              true,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
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
    ).then((result) {
      if (result == true) {
        setState(() {});
      }
    });
  }

  Color _getCardColor(String category) {
    switch (category) {
      case 'essencial':
        return CustomTheme.infoColor;
      case 'lazer':
        return CustomTheme.primaryLight;
      case 'outros':
        return CustomTheme.errorColor.withOpacity(0.01);
      default:
        return Colors.white;
    }
  }

  Widget _buildExpenseGrid(String category) {
    if (_isLoading) {
      return const ShimmerPlaceholderList();
    }

    final expenses = _controller.getExpensesByCategory(category);

    if (expenses.isEmpty) {
      return const Center(child: Text('Nenhum gasto registrado.'));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
        children:
            expenses.map((e) {
              return Container(
                decoration: BoxDecoration(
                  color: _getCardColor(category),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${e.date.day}/${e.date.month}/${e.date.year}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      'R\$ ${e.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Extrato do Mês' ,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green
          ),
          
          ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _categories.map((c) => Tab(text: _categoryLabels[c])).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((c) => _buildExpenseGrid(c)).toList(),
      ),
      floatingActionButton: CategorySpeedDial(
        onSelectCategory: (categoria) {
          _openAddExpenseModal(categoria);
        },
      ),
    );
  }
}
