import 'package:diamate/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodRelationSelector extends StatelessWidget {
  final String selectedRelation;
  final Function(String) onChanged;

  const FoodRelationSelector({
    super.key,
    required this.selectedRelation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Food Relation",
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
            _buildChip(context, "Before Food"),
            _buildChip(context, "During Food"),
            _buildChip(context, "After Food"),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    final isSelected = selectedRelation == label;
    return GestureDetector(
      onTap: () => onChanged(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.primaryColor!.withOpacity(0.1)
              : context.color.containerColor,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isSelected
                ? context.color.primaryColor!.withOpacity(0.2)
                : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.color.primaryColor!.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? context.color.primaryColor
                : context.color.textColor?.withOpacity(0.5),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
