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
            ? "${meal!.protein.toInt()}g protein · ${meal!.carbs.toInt()}g carbs"
            : "31g protein · 50g carbs";

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
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Meal Image ----
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              child: meal?.imageUrl != null && meal!.imageUrl!.isNotEmpty
                  ? Image.network(
                      meal!.imageUrl!,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 110,
                          color: isDark
                              ? context.color.cardColor
                              : Colors.grey.withValues(alpha: 0.12),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => _fallbackImage(isDark, context),
                    )
                  : _fallbackImage(isDark, context),
            ),

            // ---- Text Info ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.4,
                      fontFamily: K.sg,
                      fontWeight: FontWeight.w700,
                      color: context.color.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cal,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: K.sg,
                      fontWeight: FontWeight.w600,
                      color: context.color.primaryColor,
                    ),
                  ),
                  Text(
                    macros,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontFamily: K.sg,
                      fontWeight: FontWeight.w400,
                      color: context.color.textColor?.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // ---- More Button ----
            Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? context.color.primaryColor?.withValues(alpha: 0.2)
                    : context.color.primaryColor?.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: Center(
                child: Text(
                  "View Details",
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

  Widget _fallbackImage(bool isDark, BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      color: isDark
          ? context.color.cardColor
          : Colors.grey.withValues(alpha: 0.12),
      child: Image.asset(
        Assets.testFood,
        fit: BoxFit.contain,
      ),
    );
  }
}
