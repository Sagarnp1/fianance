import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Income'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ExpenseStatisticsTab(),
          IncomeStatisticsTab(),
        ],
      ),
    );
  }
}

class ExpenseStatisticsTab extends StatelessWidget {
  const ExpenseStatisticsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final expenseCategoryData = provider.getCategoryTotals(TransactionType.expense);
        final monthlyExpenseData = provider.getMonthlyData(TransactionType.expense);

        if (expenseCategoryData.isEmpty) {
          return const Center(
            child: Text('No expense data to display'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Breakdown',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _getSections(expenseCategoryData),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Category Breakdown',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              ...expenseCategoryData.entries.map((entry) => _buildCategoryItem(
                context,
                entry.key,
                entry.value,
                provider.totalExpense,
              )),
              const SizedBox(height: 24),
              Text(
                'Monthly Expenses',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: _buildMonthlyChart(monthlyExpenseData),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(
      BuildContext context,
      String category,
      double amount,
      double total,
      ) {
    final percentage = (amount / total) * 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs.${amount.toStringAsFixed(2)}',  // Changed currency symbol to Rs.
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections(Map<String, double> categoryData) {
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.amber,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.orange,
      Colors.indigo,
    ];

    final total = categoryData.values.fold(0.0, (sum, amount) => sum + amount);

    return categoryData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final percentage = (data.value / total) * 100;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: data.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildMonthlyChart(Map<DateTime, double> monthlyData) {
    final sortedDates = monthlyData.keys.toList()..sort();

    // Take only the last 6 months
    final dates = sortedDates.length > 6
        ? sortedDates.sublist(sortedDates.length - 6)
        : sortedDates;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: monthlyData.values.isEmpty ? 100 : monthlyData.values.reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            //tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = dates[group.x.toInt()];
              final amount = rod.toY;
              return BarTooltipItem(
                'Rs.${amount.toStringAsFixed(2)}',  // Changed currency symbol to Rs.
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < dates.length) {
                  final date = dates[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('MMM').format(date),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(dates.length, (index) {
          final date = dates[index];
          final value = monthlyData[date] ?? 0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: AppTheme.expenseColor,
                width: 15,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class IncomeStatisticsTab extends StatelessWidget {
  const IncomeStatisticsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final incomeCategoryData = provider.getCategoryTotals(TransactionType.income);
        final monthlyIncomeData = provider.getMonthlyData(TransactionType.income);

        if (incomeCategoryData.isEmpty) {
          return const Center(
            child: Text('No income data to display'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Income Sources',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _getSections(incomeCategoryData),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Category Breakdown',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              ...incomeCategoryData.entries.map((entry) => _buildCategoryItem(
                context,
                entry.key,
                entry.value,
                provider.totalIncome,
              )),
              const SizedBox(height: 24),
              Text(
                'Monthly Income',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: _buildMonthlyChart(monthlyIncomeData),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(
      BuildContext context,
      String category,
      double amount,
      double total,
      ) {
    final percentage = (amount / total) * 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs.${amount.toStringAsFixed(2)}',  // Changed currency symbol to Rs.
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections(Map<String, double> categoryData) {
    final List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.amber,
      Colors.pink,
      Colors.teal,
    ];

    final total = categoryData.values.fold(0.0, (sum, amount) => sum + amount);

    return categoryData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final percentage = (data.value / total) * 100;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: data.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildMonthlyChart(Map<DateTime, double> monthlyData) {
    final sortedDates = monthlyData.keys.toList()..sort();

    // Take only the last 6 months
    final dates = sortedDates.length > 6
        ? sortedDates.sublist(sortedDates.length - 6)
        : sortedDates;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: monthlyData.values.isEmpty ? 100 : monthlyData.values.reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            //tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = dates[group.x.toInt()];
              final amount = rod.toY;
              return BarTooltipItem(
                'Rs.${amount.toStringAsFixed(2)}',  // Changed currency symbol to Rs.
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < dates.length) {
                  final date = dates[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('MMM').format(date),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(dates.length, (index) {
          final date = dates[index];
          final value = monthlyData[date] ?? 0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: AppTheme.incomeColor,
                width: 15,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
