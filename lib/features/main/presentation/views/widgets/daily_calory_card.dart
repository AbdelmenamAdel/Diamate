import 'package:diamate/core/extensions/context_extension.dart';
import '../../../../../../constant.dart';
import '../../../../../../features/main/presentation/widgets/calorie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyCaloryCard extends StatelessWidget {
  const DailyCaloryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.cardColor,
        border: Border.all(
          color: isDark ? Colors.grey.withOpacity(0.2) : Color(0xFFE4E4E4),
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Calory',
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.color.textColor,
            ),
          ),
          SizedBox(height: 4.h),
          Stack(
            alignment: AlignmentGeometry.center,
            children: [
              SizedBox(
                height: 100.h,
                child: CalorieChart(
                  consumed: 1420,
                  goal: 1800,
                  color: Color(0xff2D9CDB),
                ),
              ),
              Column(
                children: [
                  Text(
                    "1420",
                    style: TextStyle(
                      fontFamily: K.sg,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: context.color.textColor,
                    ),
                  ),
                  Text(
                    "/1800\nKcal",
                    style: TextStyle(
                      fontFamily: K.sg,
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
