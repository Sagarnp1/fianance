import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyComparison extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const MonthlyComparison({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String title;
              if (rodIndex == 0) {
                title = 'Income';
              } else {
                title = 'Expense';
              }
              return BarTooltipItem(
                '$title: \$${rod.toY.toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
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
                if (value.toInt() >= data.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    data[value.toInt()]['month'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: _getBarGroups(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index]['income'],
            color: Colors.green,
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: data[index]['expense'],
            color: Colors.red,
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  double _getMaxY() {
    double maxValue = 0;

    for (var item in data) {
      if (item['income'] > maxValue) {
        maxValue = item['income'];
      }
      if (item['expense'] > maxValue) {
        maxValue = item['expense'];
      }
    }

    return maxValue * 1.2;
  }
}
