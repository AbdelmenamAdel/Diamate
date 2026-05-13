import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/features/food/data/models/recommended_meal_model.dart';
import 'package:diamate/features/food/presentation/views/meal_details_view.dart';
import 'package:flutter/material.dart';

class RecommededItem extends StatelessWidget {
  final RecommendedMealModel? meal;

  const RecommededItem({super.key, this.meal});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final title = meal?.title ?? "Grilled Chicken Salad";
    final cal = meal != null ? "${meal!.calories.toInt()} Cal" : "150 Cal";
    final macros =
        meal != null
            ? "${meal!.protein.toInt()} protein .${meal!.carbs.toInt()} Carbs"
            : "31 protien .50 Carbs";

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (meal != null) {
          context.push(MealDetailsView(initialMeal: meal!));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: isDark
                    ? context.color.cardColor
                    : Colors.black.withOpacity(0.05),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  Assets.testFood,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      height: 2,
                      fontFamily: K.sg,
                      fontWeight: FontWeight.w600,
                      color: context.color.textColor,
                    ),
                  ),
                  Text(
                    cal,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: K.sg,
                      fontWeight: FontWeight.w600,
                      color: context.color.textColor,
                    ),
                  ),
                  Text(
                    macros,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: K.sg,
                      fontWeight: FontWeight.w400,
                      color: context.color.textColor?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? context.color.primaryColor?.withOpacity(0.2)
                    : context.color.primaryColor?.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  "More",
                  style: TextStyle(
                    fontFamily: K.sg,
                    fontSize: 10,
                    color: isDark ? Colors.white : context.color.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
