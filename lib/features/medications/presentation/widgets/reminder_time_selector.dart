import 'package:diamate/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderTimeSelector extends StatelessWidget {
  final List<TimeOfDay> times;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const ReminderTimeSelector({
    super.key,
    required this.times,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Set Reminder Time(s)",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.color.textColor,
          ),
        ),
        SizedBox(height: 15.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: times.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            return _buildTimeItem(context, index);
          },
        ),
        SizedBox(height: 15.h),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: Icon(Icons.add, size: 20.sp),
          label: Text("Add another time"),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            side: BorderSide(color: context.color.containerColor!),
            foregroundColor: context.color.textColor?.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeItem(BuildContext context, int index) {
    final time = times[index];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: context.color.containerColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.color.containerColor!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: context.color.textColor?.withOpacity(0.5),
          ),
          SizedBox(width: 15.w),
          Text(
            time.format(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: context.color.textColor,
            ),
          ),
          Spacer(),
          if (times.length > 1)
            IconButton(
              icon: Icon(Icons.close, color: Colors.red.shade300),
              onPressed: () => onRemove(index),
            ),
        ],
      ),
    );
  }
}
