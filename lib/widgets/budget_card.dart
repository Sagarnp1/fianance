import 'package:flutter/material.dart';
import 'package:financetracker/models/transaction.dart';
import 'package:intl/intl.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final double spent;
  final VoidCallback onDelete;

  const BudgetCard({
    Key? key,
    required this.budget,
    required this.spent,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage =
        budget.limit > 0 ? (spent / budget.limit) * 100 : 0;
    final bool isOverBudget = spent > budget.limit;

    Color progressColor;
    if (percentage < 50) {
      progressColor = Colors.green;
    } else if (percentage < 80) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${DateFormat('MMM dd').format(budget.startDate)} - ${DateFormat('MMM dd').format(budget.endDate)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '\$${spent.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOverBudget ? Colors.red : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: progressColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}% used',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
