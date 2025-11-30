import 'package:diamate/constant.dart';
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
          SizedBox(
            height: 80.h,
            child: Center(
              child: Text(
                '7,500 / 10,000',
                style: TextStyle(
                  fontFamily: K.sg,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
