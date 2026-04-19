import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/features/food/data/models/meal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

class MealHistoryCard extends StatelessWidget {
  final MealModel meal;

  const MealHistoryCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: context.color.hintColor?.withOpacity(0.1) ?? Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: meal.imagePath != null
                    ? Image.file(
                        File(meal.imagePath!),
                        width: 70.w,
                        height: 70.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                      )
                    : _buildPlaceholder(context),
              ),
              SizedBox(width: 16.w),
              // Meal Name & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: context.color.textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      meal.ingredients.map((e) => e.name).join(", "),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: context.color.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: context.color.hintColor?.withOpacity(0.1)),
          SizedBox(height: 12.h),
          // Macros Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroChip(context, "Calories", "${meal.nutrition?.calories.toInt() ?? 0} kcal", Colors.orange),
              _buildMacroChip(context, "Carbs", "${meal.nutrition?.carbs.toInt() ?? 0}g", Colors.blue),
              _buildMacroChip(context, "Protein", "${meal.nutrition?.protein.toInt() ?? 0}g", Colors.green),
              _buildMacroChip(context, "Fat", "${meal.nutrition?.fat.toInt() ?? 0}g", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: context.color.primaryColor?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        Icons.restaurant_menu_rounded,
        color: context.color.primaryColor,
        size: 30.sp,
      ),
    );
  }

  Widget _buildMacroChip(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: context.color.textColor,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
