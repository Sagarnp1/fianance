import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:financetracker/providers/transaction_provider.dart';
import 'package:financetracker/widgets/spending_chart.dart';
import 'package:financetracker/widgets/category_breakdown.dart';
import 'package:financetracker/widgets/monthly_comparison.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Spending vs Saving Chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spending vs Saving',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: SpendingChart(
                          data: provider.getMonthlyData(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Category Breakdown
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense Breakdown',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 250,
                        child: CategoryBreakdown(
                          categoryExpenses: provider.getCategoryExpenses(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Monthly Comparison
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Comparison',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 250,
                        child: MonthlyComparison(
                          data: provider.getMonthlyData(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Insights
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Insights',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ...provider.getBudgetInsights().map((insight) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb_outline, size: 20),
                                const SizedBox(width: 8),
                                Expanded(child: Text(insight)),
                              ],
                            ),
                          )),
                      if (provider.getBudgetInsights().isEmpty)
                        const Text(
                            'No insights available yet. Add more transactions to get personalized insights.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
