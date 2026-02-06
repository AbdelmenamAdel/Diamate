import 'package:diamate/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DosageSelector extends StatelessWidget {
  final int amount;
  final Function(int) onChanged;

  const DosageSelector({
    super.key,
    required this.amount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dosage Amount",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.color.textColor,
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            _buildBtn(context, Icons.remove, () {
              if (amount > 1) onChanged(amount - 1);
            }),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Container(
                  key: ValueKey<int>(amount),
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: context.color.containerColor!,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      amount.toString(),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: context.color.textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildBtn(context, Icons.add, () => onChanged(amount + 1)),
          ],
        ),
      ],
    );
  }

  Widget _buildBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.color.containerColor!),
            color: context.color.cardColor,
          ),
          child: Icon(
            icon,
            size: 24.sp,
            color: context.color.textColor?.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
