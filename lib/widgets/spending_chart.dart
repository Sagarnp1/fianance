import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final expenseCategoryData = provider.getCategoryTotals(TransactionType.expense);
        
        if (expenseCategoryData.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text('No expense data to display'),
            ),
          );
        }
        
        return SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _getSections(expenseCategoryData),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  // Handle touch events if needed
                },
              ),
            ),
          ),
        );
      },
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
    
    if (total <= 0) {
      return [
        PieChartSectionData(
          color: colors[0],
          value: 1,
          title: 'No Data',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ];
    }
    
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
}

