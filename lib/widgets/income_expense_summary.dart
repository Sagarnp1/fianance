import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class IncomeExpenseSummary extends StatelessWidget {
  const IncomeExpenseSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final incomeData = provider.getMonthlyData(TransactionType.income);
        final expenseData = provider.getMonthlyData(TransactionType.expense);
        
        if (incomeData.isEmpty && expenseData.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text('No data to display'),
            ),
          );
        }
        
        // Get all dates from both maps
        final allDates = {...incomeData.keys, ...expenseData.keys}.toList()
          ..sort((a, b) => a.compareTo(b));

        if (allDates.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Text('No income or expense data available'),
                ),
              ),
            ),
          );
        }
        
        // Take only the last 6 months
        final dates = allDates.length > 6 
            ? allDates.sublist(allDates.length - 6) 
            : allDates;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Income vs Expense',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
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
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        // Income Line
                        LineChartBarData(
                          spots: _getSpots(dates, incomeData),
                          isCurved: true,
                          color: AppTheme.incomeColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.incomeColor.withOpacity(0.2),
                          ),
                        ),
                        // Expense Line
                        LineChartBarData(
                          spots: _getSpots(dates, expenseData),
                          isCurved: true,
                          color: AppTheme.expenseColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.expenseColor.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(AppTheme.incomeColor, 'Income'),
                    const SizedBox(width: 24),
                    _buildLegendItem(AppTheme.expenseColor, 'Expense'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<FlSpot> _getSpots(List<DateTime> dates, Map<DateTime, double> data) {
    if (dates.isEmpty) {
      return [const FlSpot(0, 0)];
    }
    
    return List.generate(dates.length, (index) {
      final date = dates[index];
      final value = data[date] ?? 0.0;
      return FlSpot(index.toDouble(), value);
    });
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

