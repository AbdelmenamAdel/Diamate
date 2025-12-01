import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MacroChart extends StatelessWidget {
  final double protein;
  final double fats;
  final double carbs;
  const MacroChart({
    super.key,
    required this.protein,
    required this.fats,
    required this.carbs,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: carbs,
            color: Color(0xFFBFA2D0),
            title: '',
            radius: 14,
          ),
          PieChartSectionData(
            value: protein,
            color: Color(0xffDAF1D6),
            title: '',
            radius: 14,
          ),
          PieChartSectionData(
            value: fats,
            color: Color(0xffFCDABE),
            title: '',

            radius: 14,
          ),
        ],
        startDegreeOffset: -90,
        centerSpaceRadius: 36,
        sectionsSpace: 2,
      ),
    );
  }
}
