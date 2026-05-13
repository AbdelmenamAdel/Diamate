import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/features/food/data/models/meal_model.dart';
import 'package:diamate/features/food/data/models/recommended_meal_model.dart';
import 'package:diamate/features/food/presentation/managers/food_cubit.dart';
import 'package:diamate/features/food/presentation/managers/recommended_food_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealDetailsView extends StatelessWidget {
  final RecommendedMealModel initialMeal;

  const MealDetailsView({super.key, required this.initialMeal});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(back: true, title: 'Meal Details'),
            Expanded(
              child: BlocBuilder<RecommendedFoodCubit, RecommendedFoodState>(
                builder: (context, state) {
                  // Find latest version of meal to ensure reactive save icon toggle
                  RecommendedMealModel meal = initialMeal;
                  if (state is RecommendedFoodLoaded) {
                    final allAvailable = [
                      ...state.recommendations,
                      ...state.savedMeals,
                    ];
                    final match = allAvailable.where(
                      (m) => m.id == initialMeal.id,
                    );
                    if (match.isNotEmpty) {
                      meal = match.first;
                    }
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Visual Header
                        Center(
                          child: Container(
                            height: 180.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? context.color.cardColor
                                  : Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.asset(
                                Assets.testFood,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Title & Calories Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                meal.title,
                                style: TextStyle(
                                  fontFamily: K.sg,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: context.color.textColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: context.color.primaryColor
                                    ?.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                "${meal.calories.toInt()} Kcal",
                                style: TextStyle(
                                  fontFamily: K.sg,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: context.color.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        if (meal.description.isNotEmpty)
                          Text(
                            meal.description,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: context.color.hintColor,
                              height: 1.4,
                            ),
                          ),

                        SizedBox(height: 20.h),

                        // Macros Breakdown Indicator Row
                        Row(
                          children: [
                            _macroCard(
                              context,
                              "Protein",
                              "${meal.protein.toInt()}g",
                              const Color(0xFFE57373),
                            ),
                            SizedBox(width: 8.w),
                            _macroCard(
                              context,
                              "Carbs",
                              "${meal.carbs.toInt()}g",
                              const Color(0xFF64B5F6),
                            ),
                            SizedBox(width: 8.w),
                            _macroCard(
                              context,
                              "Fats",
                              "${meal.fats.toInt()}g",
                              const Color(0xFFFFB74D),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Ingredients Section
                        if (meal.ingredients.isNotEmpty) ...[
                          Text(
                            "المكونات",
                            style: TextStyle(
                              fontFamily: K.sg,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: context.color.textColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children:
                                meal.ingredients.map((ing) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.color.containerColor,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.15),
                                      ),
                                    ),
                                    child: Text(
                                      ing,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: context.color.textColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                          SizedBox(height: 24.h),
                        ],

                        // Preparation Steps Section
                        if (meal.preparationSteps.isNotEmpty) ...[
                          Text(
                            "طريقة التحضير",
                            style: TextStyle(
                              fontFamily: K.sg,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: context.color.textColor,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: meal.preparationSteps.length,
                            itemBuilder: (context, idx) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 12.r,
                                      backgroundColor: context
                                          .color
                                          .primaryColor
                                          ?.withOpacity(0.15),
                                      child: Text(
                                        "${idx + 1}",
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: context.color.primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        meal.preparationSteps[idx],
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          color: context.color.textColor,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Sticky Bottom Toolbar
            BlocBuilder<RecommendedFoodCubit, RecommendedFoodState>(
              builder: (context, recState) {
                // Determine latest saved status
                bool isSaved = initialMeal.isSaved;
                RecommendedMealModel targetMeal = initialMeal;
                if (recState is RecommendedFoodLoaded) {
                  final allAvailable = [
                    ...recState.recommendations,
                    ...recState.savedMeals,
                  ];
                  final match = allAvailable.where(
                    (m) => m.id == initialMeal.id,
                  );
                  if (match.isNotEmpty) {
                    targetMeal = match.first;
                    isSaved = targetMeal.isSaved;
                  }
                }

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10.r,
                        offset: Offset(0, -4.h),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Save/Favorite Icon
                      InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          context.read<RecommendedFoodCubit>().toggleSaveMeal(
                            targetMeal,
                          );
                        },
                        child: Container(
                          height: 48.h,
                          width: 48.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSaved
                                  ? Colors.transparent
                                  : Colors.grey.withOpacity(0.3),
                            ),
                            color: isSaved
                                ? const Color(0xFFF25661).withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved
                                ? const Color(0xFFF25661)
                                : context.color.hintColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Log Meal Today Button
                      Expanded(
                        child: BlocConsumer<FoodCubit, FoodState>(
                          listener: (context, fState) {
                            if (fState is FoodSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "تم تسجيل الوجبة بنجاح في يومك!",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Refresh daily home cache dynamically
                              context.read<FoodCubit>().loadMealsForDate(
                                DateTime.now(),
                              );
                            } else if (fState is FoodError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(fState.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, fState) {
                            final isLoading = fState is FoodLoading;
                            return CustomButton(
                              radius: 12,
                              text: "أكلت دي النهاردة",
                              isLoading: isLoading,
                              color: const Color(0xff2D9CDB),
                              onTap:
                                  isLoading
                                      ? () {}
                                      : () {
                                          final ingModels =
                                              targetMeal.ingredients.isEmpty
                                                  ? [
                                                      IngredientModel(
                                                        name: targetMeal.title,
                                                        quantityGrams: 100,
                                                      ),
                                                    ]
                                                  : targetMeal.ingredients
                                                      .map(
                                                        (s) => IngredientModel(
                                                          name: s,
                                                          quantityGrams: 100,
                                                        ),
                                                      )
                                                      .toList();

                                          context.read<FoodCubit>().addMeal(
                                            name: targetMeal.title,
                                            ingredients: ingModels,
                                          );
                                        },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: context.color.hintColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
