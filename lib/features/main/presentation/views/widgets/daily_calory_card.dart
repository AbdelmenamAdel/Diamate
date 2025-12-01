import 'package:diamate/constant.dart';
import 'package:diamate/features/main/presentation/widgets/calorie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyCaloryCard extends StatelessWidget {
  const DailyCaloryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffF5F5F5),
        border: Border.all(color: Color(0xFFE4E4E4)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Calory',
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 16,
              fontWeight: FontWeight.w700,
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
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "/1800\nKcal",
                    style: TextStyle(
                      fontFamily: K.sg,
                      fontSize: 12,
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
