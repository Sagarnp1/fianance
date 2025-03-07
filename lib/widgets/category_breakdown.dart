import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryBreakdown extends StatelessWidget {
  final Map<String, double> categoryExpenses;

  const CategoryBreakdown({
    Key? key,
    required this.categoryExpenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryExpenses.isEmpty) {
      return const Center(
        child: Text('No expense data available'),
      );
    }

    // Prepare data for pie chart
    final List<MapEntry<String, double>> sortedEntries = categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
      
    // Get total expenses
    final double totalExpenses = categoryExpenses.values.fold(0, (sum, value) => sum + value);

    return Row(
      children: [
        // Pie Chart
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _getSections(sortedEntries, totalExpenses),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  // Handle touch events if needed
                },
              ),
            ),
          ),
        ),
        
        // Legend
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sortedEntries.take(5).map((entry) {
                final percentage = (entry.value / totalExpenses) * 100;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(entry.key),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getSections(
    List<MapEntry<String, double>> entries,
    double total,
  ) {
    return entries.take(5).map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(String category) {
    final Map<String, Color> categoryColors = {
      'Food': Colors.red,
      'Transportation': Colors.blue,
      'Entertainment': Colors.purple,
      'Shopping': Colors.orange,
      'Utilities': Colors.teal,
      'Housing': Colors.indigo,
      'Health': Colors.pink,
      'Education': Colors.amber,
      'Travel': Colors.green,
      'Other': Colors.grey,
    };
    
    return categoryColors[category] ?? Colors.grey;
  }
}

