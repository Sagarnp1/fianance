import 'package:flutter/material.dart';
import 'package:financetracker/models/transaction.dart';
import 'package:financetracker/screens/add_transaction_screen.dart';
import 'package:financetracker/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort transactions by date (newest first)
    final sortedTransactions = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    if (sortedTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first transaction by tapping the + button',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Group transactions by date
    Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in sortedTransactions) {
      final dateStr = DateFormat('yyyy-MM-dd').format(transaction.date);

      if (groupedTransactions.containsKey(dateStr)) {
        groupedTransactions[dateStr]!.add(transaction);
      } else {
        groupedTransactions[dateStr] = [transaction];
      }
    }

    return ListView.builder(
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateStr = groupedTransactions.keys.elementAt(index);
        final transactionsForDate = groupedTransactions[dateStr]!;
        final date = DateTime.parse(dateStr);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _formatDate(date),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
              ),
            ),
            ...transactionsForDate.map(
                (transaction) => _buildTransactionItem(context, transaction)),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final color = transaction.type == TransactionType.income
        ? Colors.green
        : Theme.of(context).colorScheme.error;

    final icon = transaction.type == TransactionType.income
        ? Icons.arrow_downward
        : Icons.arrow_upward;

    final amountPrefix = transaction.type == TransactionType.income ? '+' : '-';

    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Transaction'),
              content: const Text(
                  'Are you sure you want to delete this transaction?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        Provider.of<TransactionProvider>(context, listen: false)
            .deleteTransaction(transaction.id);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(transaction.category),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              DateFormat('h:mm a').format(transaction.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddTransactionScreen(transaction: transaction),
            ),
          );
        },
      ),
    );
  }
}
