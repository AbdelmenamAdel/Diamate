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
    final macros = meal != null
        ? "${meal!.protein.toInt()}g protein · ${meal!.carbs.toInt()}g carbs"
        : "31g protein · 50g carbs";

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        if (meal != null) {
          context.push(MealDetailsView(initialMeal: meal!));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? context.color.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // Fill the entire grid cell
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image (fixed height) ──────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: SizedBox(
                height: 120,
                child: meal?.imageUrl != null && meal!.imageUrl!.isNotEmpty
                    ? Image.network(
                        meal!.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return _placeholder(isDark, context);
                        },
                        errorBuilder: (_, __, ___) =>
                            _fallbackAsset(isDark, context),
                      )
                    : _fallbackAsset(isDark, context),
              ),
            ),

            // ── Text info (fills remaining space) ─────────────────
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        fontFamily: K.sg,
                        fontWeight: FontWeight.w700,
                        color: context.color.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Calories
                    Text(
                      cal,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: K.sg,
                        fontWeight: FontWeight.w700,
                        color: context.color.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Macros
                    Text(
                      macros,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontFamily: K.sg,
                        fontWeight: FontWeight.w400,
                        color: context.color.textColor
                            ?.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── View Details button (always at bottom) ─────────────
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: isDark
                    ? context.color.primaryColor?.withValues(alpha: 0.18)
                    : context.color.primaryColor?.withValues(alpha: 0.09),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "View Details",
                style: TextStyle(
                  fontFamily: K.sg,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : context.color.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(bool isDark, BuildContext context) {
    return Container(
      color: isDark
          ? context.color.cardColor
          : Colors.grey.withValues(alpha: 0.1),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _fallbackAsset(bool isDark, BuildContext context) {
    return Container(
      color: isDark
          ? context.color.cardColor
          : Colors.grey.withValues(alpha: 0.1),
      child: Image.asset(
        Assets.testFood,
        fit: BoxFit.contain,
      ),
    );
  }
}
