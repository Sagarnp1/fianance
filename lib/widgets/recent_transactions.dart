import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactions({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No transactions yet. Add one!',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: transaction.type == TransactionType.income
                    ? AppTheme.incomeColor.withOpacity(0.2)
                    : AppTheme.expenseColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction.type == TransactionType.income
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: transaction.type == TransactionType.income
                    ? AppTheme.incomeColor
                    : AppTheme.expenseColor,
              ),
            ),
            title: Text(
              transaction.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${transaction.category} • ${DateFormat('MMM dd').format(transaction.date)}',
            ),
            trailing: Text(
              '${transaction.type == TransactionType.expense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.type == TransactionType.income
                    ? AppTheme.incomeColor
                    : AppTheme.expenseColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

