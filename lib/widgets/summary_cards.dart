import 'package:flutter/material.dart';

class SummaryCards extends StatelessWidget {
  final double income;
  final double expense;
  final double savings;

  const SummaryCards({
    Key? key,
    required this.income,
    required this.expense,
    required this.savings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSummaryCard(
                  context,
                  title: 'Income',
                  amount: income,
                  icon: Icons.arrow_downward,
                  color: Colors.green,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  context,
                  title: 'Expense',
                  amount: expense,
                  icon: Icons.arrow_upward,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  context,
                  title: 'Savings',
                  amount: savings,
                  icon: Icons.savings,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

