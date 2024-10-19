import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/features/dashboard/data/models/sales_chart.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


  import 'dart:math'; // Importing the math library
class LineChartWidget<T> extends StatelessWidget {
  final List<T> chartData;
  final Color lineColor;
  final String Function(T) getDate;
  final double Function(T) getValue;

  const LineChartWidget({
    Key? key,
    required this.chartData,
    required this.lineColor,
    required this.getDate,
    required this.getValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(_buildLineChartData()),
    );
  }

  LineChartData _buildLineChartData() {
    List<Color> gradientColors = [
      lineColor,
      lineColor.withOpacity(0.5),
    ];

    double maxY = _getMaxY();
    double maxX = chartData.isNotEmpty ? chartData.length.toDouble() - 1 : 1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: maxY > 0 ? maxY / 5 : 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.black.withOpacity(0.3),
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.black.withOpacity(0.3),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              return Text(
                _formatCurrencyShort(value * 1000000),
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < 0 || value.toInt() >= chartData.length) {
                return const Text('');
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 2,
                child: Text(
                  getDate(chartData[value.toInt()]),  // Use the provided date getter
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: lineColor),
      ),
      minX: 0,
      maxX: maxX > 0 ? maxX : 1,
      minY: 0,
      maxY: maxY > 0 ? maxY : 1,
      lineBarsData: [
        LineChartBarData(
          spots: chartData.asMap().entries.map((entry) {
            int index = entry.key;
            T data = entry.value;
            return FlSpot(index.toDouble(), getValue(data) / 1000000);
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  double _getMaxY() {
    if (chartData.isEmpty) return 0;
    double maxVal = chartData.map((data) => getValue(data)).reduce((a, b) => a > b ? a : b);
    return (maxVal / 1000000).ceilToDouble();
  }

  String _formatCurrencyShort(double value) {
    if (value >= 1000000000) {
      return (value % 1000000000 == 0)
          ? '${(value / 1000000000).toStringAsFixed(0)}B'
          : '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return (value % 1000000 == 0)
          ? '${(value / 1000000).toStringAsFixed(0)}M'
          : '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return (value % 1000 == 0)
          ? '${(value / 1000).toStringAsFixed(0)}K'
          : '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}
