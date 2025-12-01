import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CalorieChart extends StatelessWidget {
  final int consumed;
  final int goal;
  final Color color;
  const CalorieChart({
    super.key,
    required this.consumed,
    required this.goal,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = goal - consumed;
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: consumed.toDouble(),
            color: color,
            title: '',
            radius: 14,
          ),
          PieChartSectionData(
            value: remaining.toDouble(),
            color: color.withOpacity(0.15),
            title: '',
            radius: 13,
          ),
        ],
        startDegreeOffset: -90,
        centerSpaceRadius: 44,
        sectionsSpace: 0,
      ),
    );
  }
}
