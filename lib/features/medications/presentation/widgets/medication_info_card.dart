import 'package:diamate/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicationInfoCard extends StatelessWidget {
  const MedicationInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.color.primaryColor!.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.color.primaryColor!.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: context.color.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            "Record your medications and their schedules... and we'll remind you. Your health matters to us, and it's our mission to protect it.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.color.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
