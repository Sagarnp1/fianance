import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Budget',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            const BudgetOverview(),
            const SizedBox(height: 24),
            Text(
              'Category Budgets',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            const CategoryBudgets(),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to budget creation/edit screen
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Budget'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetOverview extends StatelessWidget {
  const BudgetOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final spent = provider.totalExpense;
        const budget = 2000.0; // Fixed budget amount for demo
        final remaining = budget - spent;
        final percentage = (spent / budget) * 100;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Budget',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\Rs${budget.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LinearProgressIndicator(
                  value: percentage / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage > 90 ? Colors.red : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBudgetItem(
                      'Spent',
                      spent,
                      AppTheme.expenseColor,
                    ),
                    _buildBudgetItem(
                      'Remaining',
                      remaining,
                      AppTheme.incomeColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBudgetItem(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '\Rs${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class CategoryBudgets extends StatelessWidget {
  const CategoryBudgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryBudgets = [
      {
        'category': 'Food',
        'budget': 500.0,
        'spent': 320.0,
      },
      {
        'category': 'Transportation',
        'budget': 300.0,
        'spent': 180.0,
      },
      {
        'category': 'Entertainment',
        'budget': 200.0,
        'spent': 150.0,
      },
      {
        'category': 'Shopping',
        'budget': 400.0,
        'spent': 380.0,
      },
      {
        'category': 'Utilities',
        'budget': 250.0,
        'spent': 220.0,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryBudgets.length,
      itemBuilder: (context, index) {
        final item = categoryBudgets[index];
        final double spent = item['spent'] as double;
        final double budget = item['budget'] as double;
        final double percentage = (spent / budget) * 100;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['category'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\Rs${spent.toStringAsFixed(2)} / \Rs${budget.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: percentage / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage > 90
                        ? Colors.red
                        : percentage > 70
                        ? Colors.orange
                        : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rs.{percentage.toStringAsFixed(1)}% used',
                  style: TextStyle(
                    color: percentage > 90 ? Colors.red : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
