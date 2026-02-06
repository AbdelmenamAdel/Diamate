import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MedicationTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  const MedicationTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Medication Type",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.color.textColor,
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTypeItem(context, "Tablet", Assets.tablet),
            _buildTypeItem(context, "Injection", Assets.injection),
            _buildTypeItem(context, "Drops", Assets.glucose),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeItem(BuildContext context, String type, String asset) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () => onChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.primaryColor!.withOpacity(0.05)
              : context.color.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? context.color.primaryColor!
                : context.color.containerColor!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.color.primaryColor!.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              asset,
              height: 28.sp,
              width: 28.sp,
              color: context.color.textColor?.withOpacity(0.5),
              colorFilter: ColorFilter.mode(
                isSelected
                    ? context.color.primaryColor!
                    : context.color.textColor!.withOpacity(0.5),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              type,
              style: TextStyle(
                color: isSelected
                    ? context.color.primaryColor
                    : context.color.textColor?.withOpacity(0.5),
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
