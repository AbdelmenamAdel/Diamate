import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/features/glucose/presentation/managers/glucose_cubit.dart';
import 'package:diamate/features/glucose/data/models/glucose_reading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class GlucoseGraph extends StatelessWidget {
  const GlucoseGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlucoseCubit, GlucoseState>(
      builder: (context, state) {
        final readings = state is GlucoseLoaded
            ? state.readings
            : <GlucoseReading>[];

        if (readings.isEmpty) {
          return _buildEmptyState(context);
        }

        // Sort readings by timestamp (ascending for graph)
        final sortedReadings = readings.toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

        // Use all readings to match "profile glucose readings list" in real-time
        final displayReadings = sortedReadings;

        return _buildChart(context, displayReadings);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 240.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.color.hintColor!.withOpacity(0.1)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 48.sp,
              color: context.color.hintColor?.withOpacity(0.5),
            ),
            SizedBox(height: 8.h),
            Text(
              'No readings yet',
              style: TextStyle(
                fontSize: 14.sp,
                color: context.color.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Add your first glucose reading',
              style: TextStyle(
                fontSize: 12.sp,
                color: context.color.hintColor?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<GlucoseReading> displayReadings,
  ) {
    return Container(
      height: 240.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: context.color.hintColor!.withOpacity(0.1)),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: context.color.hintColor?.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= displayReadings.length) {
                    return const SizedBox();
                  }
                  final reading = displayReadings[value.toInt()];
                  final time = DateFormat('HH:mm').format(reading.timestamp);
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: context.color.hintColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: context.color.hintColor,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (displayReadings.length - 1).toDouble(),
          minY: 0,
          maxY:
              (displayReadings
                          .map((e) => e.value)
                          .reduce((a, b) => a > b ? a : b) +
                      50)
                  .clamp(200, 600)
                  .toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: displayReadings
                  .asMap()
                  .entries
                  .map(
                    (entry) => FlSpot(entry.key.toDouble(), entry.value.value),
                  )
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: const Color(0xff2D9CDB),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor:
                        context.color.primaryColor ?? const Color(0xff2D9CDB),
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (context.color.primaryColor ?? const Color(0xff2D9CDB))
                        .withOpacity(0.3),
                    (context.color.primaryColor ?? const Color(0xff2D9CDB))
                        .withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final reading = displayReadings[spot.x.toInt()];
                  return LineTooltipItem(
                    '${reading.value.toInt()} mg/dL\n${DateFormat('MMM d, HH:mm').format(reading.timestamp)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
