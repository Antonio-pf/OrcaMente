import 'package:flutter/material.dart';
import 'package:orcamente/components/widgets/custom_text_field.dart';
import 'package:orcamente/components/widgets/expense/summary_card.dart';
import 'package:orcamente/components/widgets/shimmer_list.dart';
import 'package:orcamente/components/common/gradient_background.dart';
import 'package:orcamente/components/common/standard_card.dart';
import 'package:orcamente/components/common/standard_button.dart';
import 'package:orcamente/controllers/expense_controller.dart';
import 'package:orcamente/repositories/expense_repository.dart';
import 'package:orcamente/models/expense.dart';
import 'package:orcamente/styles/custom_theme.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageViewState();
}

class _ExpensePageViewState extends State<ExpensePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ExpenseController _controller;

  final List<String> _categories = ['essencial', 'lazer', 'outros'];
  final Map<String, String> _categoryLabels = {
    'essencial': 'Essenciais',
    'lazer': 'Lazer',
    'outros': 'Outros',
  };
  final Map<String, Color> _categoryColors = {
    'essencial': CustomTheme.primaryColor,
    'lazer': CustomTheme.secondaryColor,
    'outros': Colors.orange,
  };

  bool _isLoading = true;

  // Estado para pesquisa e ordenação
  String _searchQuery = '';
  String _sortCriteria = 'data'; // 'data' ou 'descricao'

  @override
  void initState() {
    super.initState();
    _controller = ExpenseController(ExpenseRepository());
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final result = await _controller.fetchExpenses();

    if (mounted) {
      result.when(
        success: (_) {
          setState(() => _isLoading = false);
        },
        failure: (error, exception) {
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Erro ao carregar despesas: $error')),
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
                  label: 'TENTAR NOVAMENTE',
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() => _isLoading = true);
                    _loadExpenses();
                  },
                ),
              ),
            );
          }
        },
      );
    }
  }

  Future<void> _refreshExpenses() async {
    await _loadExpenses();
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

  List<Expense> _getFilteredExpenses(String category) {
    final expenses = _controller.getExpensesByCategory(category);

    final filtered =
        expenses.where((e) {
          final desc = e.description.toLowerCase();
          final query = _searchQuery.toLowerCase();
          return desc.contains(query);
        }).toList();

    if (_sortCriteria == 'data') {
      filtered.sort(
        (a, b) => b.date.compareTo(a.date),
      ); // mais recente primeiro
    } else if (_sortCriteria == 'descricao') {
      filtered.sort((a, b) => a.description.compareTo(b.description));
    }

    return filtered;
  }

  void _openAddExpenseModal(String category) {
    final descController = TextEditingController();
    final valueController = TextEditingController();

    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
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
                      // Handle bar
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      Row(
                        children: [
                          IconBadge(
                            icon: Icons.receipt_long,
                            iconColor: _categoryColors[category]!,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Novo Gasto - ${_categoryLabels[category]}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      CustomTextField(
                        controller: descController,
                        hintText: 'Descrição',
                        icon: Icons.edit,
                        onChanged: (_) {
                          if (errorText != null)
                            setModalState(() => errorText = null);
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: valueController,
                        hintText: 'Valor',
                        icon: Icons.attach_money,
                        onChanged: (_) {
                          if (errorText != null)
                            setModalState(() => errorText = null);
                        },
                      ),
                      if (errorText != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  errorText!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        child: StandardButton(
                          text: 'Salvar',
                          icon: Icons.save,
                          onPressed: () async {
                            final desc = descController.text.trim();
                            final value =
                                double.tryParse(
                                  valueController.text.replaceAll(',', '.'),
                                ) ??
                                0;

                            if (desc.isEmpty || value <= 0) {
                              setModalState(() {
                                errorText =
                                    'Preencha todos os campos corretamente.';
                              });
                              return;
                            }

                            final result = await _controller.addExpense(
                              desc,
                              value,
                              category,
                            );

                            result.when(
                              success: (_) {
                                Navigator.pop(context);
                                setState(() {}); // Atualiza lista
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text('Despesa adicionada com sucesso!'),
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
                              },
                              failure: (error, exception) {
                                setModalState(() {
                                  errorText = 'Erro ao salvar despesa: $error';
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
        return CustomTheme.primaryColor.withOpacity(0.08);
      case 'lazer':
        return CustomTheme.secondaryColor.withOpacity(0.08);
      case 'outros':
        return Colors.orange.withOpacity(0.08);
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getCardBorderColor(String category) {
    switch (category) {
      case 'essencial':
        return CustomTheme.primaryColor.withOpacity(0.2);
      case 'lazer':
        return CustomTheme.secondaryColor.withOpacity(0.2);
      case 'outros':
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.grey[300]!;
    }
  }

  Widget _buildExpenseList(String category) {
    if (_isLoading) {
      return const ShimmerPlaceholderList(itemCount: 2);
    }

    final filteredExpenses = _getFilteredExpenses(category);

    if (filteredExpenses.isEmpty) {
      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _categoryColors[category]!.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    size: 40,
                    color: _categoryColors[category]!.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum gasto registrado',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => _openAddExpenseModal(category),
                  icon: Icon(Icons.add, color: _categoryColors[category], size: 18),
                  label: Text(
                    'Adicionar primeiro gasto',
                    style: TextStyle(
                      color: _categoryColors[category],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    backgroundColor: _categoryColors[category]!.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshExpenses,
      color: CustomTheme.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filteredExpenses.length,
        itemBuilder: (context, index) {
          final expense = filteredExpenses[index];

          return Dismissible(
            key: Key(expense.id),
            background: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await _controller.removeExpense(expense.id);
              setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(child: Text('Despesa removida')),
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
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: _getCardColor(category),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getCardBorderColor(category),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _categoryColors[category]!.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.receipt,
                    color: _categoryColors[category],
                    size: 20,
                  ),
                ),
                title: Text(
                  expense.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                trailing: Text(
                  'R\$ ${expense.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _categoryColors[category],
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
      body: GradientBackground(
        child: Column(
          children: [
            _buildSummaryCard(),

            // CAMPO DE PESQUISA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar despesas...',
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: CustomTheme.primaryColor,
                  ),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: CustomTheme.primaryColor,
                      width: 2.5,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // BOTÕES DE ORDENAÇÃO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Ordenar por:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF616161),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Data'),
                    selected: _sortCriteria == 'data',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _sortCriteria = 'data';
                        });
                      }
                    },
                    selectedColor: CustomTheme.primaryColor.withOpacity(0.2),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _sortCriteria == 'data'
                          ? CustomTheme.primaryColor
                          : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: _sortCriteria == 'data'
                          ? CustomTheme.primaryColor
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Descrição'),
                    selected: _sortCriteria == 'descricao',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _sortCriteria = 'descricao';
                        });
                      }
                    },
                    selectedColor: CustomTheme.primaryColor.withOpacity(0.2),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _sortCriteria == 'descricao'
                          ? CustomTheme.primaryColor
                          : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: _sortCriteria == 'descricao'
                          ? CustomTheme.primaryColor
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            TabBar(
              controller: _tabController,
              tabs:
                  _categories.map((c) => Tab(text: _categoryLabels[c])).toList(),
              labelColor: CustomTheme.primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: CustomTheme.primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories.map((c) => _buildExpenseList(c)).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final currentIndex = _tabController.index;
          _openAddExpenseModal(_categories[currentIndex]);
        },
        backgroundColor: CustomTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Adicionar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 4,
      ),
    );
  }
}
