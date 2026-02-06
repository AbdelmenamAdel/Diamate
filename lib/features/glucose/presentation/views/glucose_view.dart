import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_button.dart';

import 'package:diamate/features/glucose/presentation/managers/glucose_cubit.dart';
import 'package:diamate/features/glucose/presentation/widgets/add_glucose_dialog.dart';
import 'package:diamate/features/glucose/presentation/widgets/glucose_camera_scanner.dart';
import 'package:diamate/features/glucose/presentation/widgets/glucose_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class GlucoseView extends StatelessWidget {
  const GlucoseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GlucoseCubit>(),
      child: const _GlucoseViewContent(),
    );
  }
}

class _GlucoseViewContent extends StatelessWidget {
  const _GlucoseViewContent();

  Future<void> _showAddManualDialog(BuildContext context) async {
    final result = await AddGlucoseBottomSheet.show(context);

    if (result != null && context.mounted) {
      await context.read<GlucoseCubit>().addReading(
        value: result['value'] as double,
        source: 'manual',
        notes: result['notes'] as String?,
        measurementType: result['measurementType'] as String? ?? 'random',
      );
    }
  }

  Future<void> _showCameraScanner(BuildContext context) async {
    final result = await GlucoseCameraScanner.show(context);

    if (result != null && context.mounted) {
      await context.read<GlucoseCubit>().addReading(
        value: result['value'] as double,
        source: 'camera',
        imagePath: result['imagePath'] as String?,
        measurementType: 'random', // Camera scans default to random
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: BlocBuilder<GlucoseCubit, GlucoseState>(
        builder: (context, state) {
          final cubit = context.read<GlucoseCubit>();

          final latestReading = cubit.latestReading;
          final averageReading = cubit.averageReading;
          final highestReading = cubit.highestReading;
          final lowestReading = cubit.lowestReading;

          return SingleChildScrollView(
            child: Column(
              spacing: 16.h,
              children: [
                const CustomAppBar(back: false, title: "Glucose monitor"),

                // Latest Reading Display
                if (latestReading != null) ...[
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            latestReading.value.toInt().toString(),
                            style: TextStyle(
                              fontFamily: K.sg,
                              fontSize: 48.sp,
                              fontWeight: FontWeight.w900,
                              color: context.color.textColor,
                            ),
                          ),
                          Text(
                            " mg/dL",
                            style: TextStyle(
                              fontFamily: K.sg,
                              fontSize: 20.sp,
                              color: context.color.hintColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        latestReading.status,
                        style: TextStyle(
                          fontFamily: K.sg,
                          fontSize: 18.sp,
                          color: Color(
                            int.parse(
                                  latestReading.statusColor.substring(1),
                                  radix: 16,
                                ) +
                                0xFF000000,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Updated ${_getTimeAgo(latestReading.timestamp)}",
                        style: TextStyle(
                          fontFamily: K.sg,
                          fontSize: 12.sp,
                          color: context.color.hintColor,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  SizedBox(height: 10.h),
                  Text(
                    "No readings yet",
                    style: TextStyle(
                      fontFamily: K.sg,
                      fontSize: 18.sp,
                      color: context.color.hintColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

                // Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    spacing: 12.w,
                    children: [
                      Expanded(
                        child: CustomButton(
                          radius: 12,
                          onTap: () => _showAddManualDialog(context),
                          text: "+ Manual",
                          color: const Color(0xff2D9CDB),
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          radius: 12,
                          onTap: () => _showCameraScanner(context),
                          text: "Scan",
                          color: const Color(0xff45C588),
                        ),
                      ),
                    ],
                  ),
                ),

                // Statistics Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12.w,
                  children: [
                    GlucoseLevel(
                      level: "High",
                      value: highestReading,
                      isHigh: true,
                    ),
                    GlucoseLevel(
                      level: "Average",
                      value: averageReading,
                      isAvarage: true,
                    ),
                    GlucoseLevel(
                      level: "Low",
                      value: lowestReading,
                      isLow: true,
                    ),
                  ],
                ),

                // Graph Visualization
                const GlucoseGraph(),

                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}

class GlucoseLevel extends StatelessWidget {
  const GlucoseLevel({
    super.key,
    required this.level,
    required this.value,
    this.isAvarage = false,
    this.isHigh = false,
    this.isLow = false,
  });

  final String level;
  final double value;
  final bool isAvarage;
  final bool isHigh;
  final bool isLow;

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (isAvarage) return const Color(0xff45C588);
      if (isHigh) return const Color(0xffF2994A);
      if (isLow) return const Color(0xffF25661);
      return const Color(0xffF25661);
    }

    return Container(
      height: 85.h,
      width: 95.w,
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.color.hintColor!.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2.h,
        children: [
          Text(
            level,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: K.sg,
              fontWeight: FontWeight.w600,
              color: context.color.hintColor,
            ),
          ),
          Text(
            value.toInt().toString(),
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: K.sg,
              color: getColor(),
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            "mg/dL",
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: K.sg,
              color: context.color.hintColor?.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
