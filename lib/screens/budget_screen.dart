import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financetracker/models/transaction.dart';
import 'package:financetracker/providers/transaction_provider.dart';
import 'package:financetracker/widgets/budget_card.dart';
import 'package:financetracker/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budgets',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                if (provider.budgets.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No budgets yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a budget to track your spending',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.budgets.length,
                    itemBuilder: (context, index) {
                      final budget = provider.budgets[index];

                      // Calculate spent amount
                      double spent = provider.transactions
                          .where((t) => t.type == TransactionType.expense)
                          .where((t) => t.category == budget.category)
                          .where((t) =>
                              t.date.isAfter(budget.startDate) &&
                              t.date.isBefore(budget.endDate))
                          .fold(0, (sum, t) => sum + t.amount);

                      return BudgetCard(
                        budget: budget,
                        spent: spent,
                        onDelete: () {
                          provider.deleteBudget(budget.id);
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddBudgetDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _limitController = TextEditingController();
    String _category = 'Food';
    DateTime _startDate = DateTime.now();
    DateTime _endDate = DateTime.now().add(const Duration(days: 30));

    final List<String> _categories = [
      'Food',
      'Transportation',
      'Entertainment',
      'Shopping',
      'Utilities',
      'Housing',
      'Health',
      'Education',
      'Travel',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Budget'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _category,
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _category = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _limitController,
                        labelText: 'Budget Limit',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a limit';
                          }
                          try {
                            double.parse(value);
                          } catch (e) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );

                                if (picked != null && picked != _startDate) {
                                  setState(() {
                                    _startDate = picked;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  DateFormat('MMM dd').format(_startDate),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _endDate,
                                  firstDate: _startDate,
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)),
                                );

                                if (picked != null && picked != _endDate) {
                                  setState(() {
                                    _endDate = picked;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'End Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  DateFormat('MMM dd').format(_endDate),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final provider = Provider.of<TransactionProvider>(context,
                          listen: false);

                      final budget = Budget(
                        category: _category,
                        limit: double.parse(_limitController.text.trim()),
                        startDate: _startDate,
                        endDate: _endDate,
                      );

                      provider.addBudget(budget);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
