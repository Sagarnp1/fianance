import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const SpendingChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
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
              reservedSize: 30,
              interval: 1,
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
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: 0,
        maxY: _getMaxY(),
        lineBarsData: [
          // Income Line
          LineChartBarData(
            spots: _getSpots('income'),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.1),
            ),
          ),
          // Expense Line
          LineChartBarData(
            spots: _getSpots('expense'),
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withOpacity(0.1),
            ),
          ),
          // Savings Line
          LineChartBarData(
            spots: _getSpots('savings'),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.shade800,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final dataPoint = data[spot.x.toInt()];
                String title;

                if (spot.barIndex == 0) {
                  title = 'Income';
                } else if (spot.barIndex == 1) {
                  title = 'Expense';
                } else {
                  title = 'Savings';
                }

                return LineTooltipItem(
                  '$title: \$${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getSpots(String key) {
    return List.generate(data.length, (index) {
      return FlSpot(index.toDouble(), data[index][key].toDouble());
    });
  }

  double _getMaxY() {
    double maxIncome = 0;
    double maxExpense = 0;
    double maxSavings = 0;

    for (var item in data) {
      if (item['income'] > maxIncome) {
        maxIncome = item['income'];
      }
      if (item['expense'] > maxExpense) {
        maxExpense = item['expense'];
      }
      if (item['savings'] > maxSavings) {
        maxSavings = item['savings'];
      }
    }

    return [maxIncome, maxExpense, maxSavings].reduce((a, b) => a > b ? a : b) *
        1.2;
  }
}
