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

class MealDetailsView extends StatefulWidget {
  final RecommendedMealModel initialMeal;

  const MealDetailsView({super.key, required this.initialMeal});

  @override
  State<MealDetailsView> createState() => _MealDetailsViewState();
}

class _MealDetailsViewState extends State<MealDetailsView> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomAppBar(back: true, title: isArabic ? 'تفاصيل الوجبة' : 'Meal Details'),
            ),
            Expanded(
              child: BlocBuilder<RecommendedFoodCubit, RecommendedFoodState>(
                builder: (context, state) {
                  // Find latest version of meal to ensure reactive save icon toggle
                  RecommendedMealModel meal = widget.initialMeal;
                  if (state is RecommendedFoodLoaded) {
                    final allAvailable = [
                      ...state.recommendations,
                      ...state.savedMeals,
                    ];
                    final match = allAvailable.where(
                      (m) => m.id == widget.initialMeal.id,
                    );
                    if (match.isNotEmpty) {
                      meal = match.first;
                    }
                  }

                  // Build image list — prefer imageUrls, fallback to imageUrl
                  final List<String> images = meal.imageUrls.isNotEmpty
                      ? meal.imageUrls
                      : (meal.imageUrl != null && meal.imageUrl!.isNotEmpty
                          ? [meal.imageUrl!]
                          : []);

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Image Carousel ──────────────────────────
                        _ImageCarousel(
                          images: images,
                          isDark: isDark,
                          pageController: _pageController,
                          currentPage: _currentPage,
                          onPageChanged: (i) =>
                              setState(() => _currentPage = i),
                        ),
                        SizedBox(height: 16.h),

                        // Title & Calories Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                meal.displayTitle(isArabic),
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
                                color: context.color.primaryColor?.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                "${meal.calories.toInt()} ${isArabic ? 'سعر' : 'Kcal'}",
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

                        if (meal.displayDescription(isArabic).isNotEmpty)
                          Text(
                            meal.displayDescription(isArabic),
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
                              isArabic ? "بروتين" : "Protein",
                              "${meal.protein.toInt()}g",
                              const Color(0xFFE57373),
                            ),
                            SizedBox(width: 8.w),
                            _macroCard(
                              context,
                              isArabic ? "كربوهيدرات" : "Carbs",
                              "${meal.carbs.toInt()}g",
                              const Color(0xFF64B5F6),
                            ),
                            SizedBox(width: 8.w),
                            _macroCard(
                              context,
                              isArabic ? "دهون" : "Fats",
                              "${meal.fats.toInt()}g",
                              const Color(0xFFFFB74D),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        // Ingredients Section
                        // Ingredients Section
                        if (meal.displayIngredients(isArabic).isNotEmpty) ...[
                          Text(
                            isArabic ? "المكونات" : "Ingredients",
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
                            children: meal.displayIngredients(isArabic).map((ing) {
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
                        if (meal.displaySteps(isArabic).isNotEmpty) ...[
                          Text(
                            isArabic ? "طريقة التحضير" : "Preparation Steps",
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
                            itemCount: meal.displaySteps(isArabic).length,
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
                                        meal.displaySteps(isArabic)[idx],
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
                bool isSaved = widget.initialMeal.isSaved;
                RecommendedMealModel targetMeal = widget.initialMeal;
                if (recState is RecommendedFoodLoaded) {
                  final allAvailable = [
                    ...recState.recommendations,
                    ...recState.savedMeals,
                  ];
                  final match = allAvailable.where(
                    (m) => m.id == widget.initialMeal.id,
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
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? "تم تسجيل الوجبة بنجاح في يومك!"
                                        : "Meal successfully logged for today!",
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
                              text: isArabic ? "أكلت دي النهاردة" : "I Ate This Today",
                              isLoading: isLoading,
                              color: const Color(0xff2D9CDB),
                              onTap: isLoading
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

// ═══════════════════════════════════════════════════════════════
// Image Carousel with PageView + animated dot indicators
// ═══════════════════════════════════════════════════════════════
class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  final bool isDark;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _ImageCarousel({
    required this.images,
    required this.isDark,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = images.isNotEmpty;
    final showDots = images.length > 1;

    return Column(
      children: [
        // ── PageView ──────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: SizedBox(
            height: 230.h,
            width: double.infinity,
            child: hasImages
                ? PageView.builder(
                    controller: pageController,
                    onPageChanged: onPageChanged,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return _NetImage(
                        url: images[index],
                        isDark: isDark,
                        context: context,
                      );
                    },
                  )
                : _FallbackImage(isDark: isDark),
          ),
        ),

        // ── Dots indicator (only if multiple images) ──────────
        if (showDots) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final isActive = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? context.color.primaryColor
                      : context.color.primaryColor?.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _NetImage extends StatelessWidget {
  final String url;
  final bool isDark;
  final BuildContext context;

  const _NetImage({
    required this.url,
    required this.isDark,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: isDark
              ? ctx.color.cardColor
              : Colors.grey.withValues(alpha: 0.08),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ctx.color.primaryColor,
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _FallbackImage(isDark: isDark),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  final bool isDark;
  const _FallbackImage({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark
          ? context.color.cardColor
          : Colors.grey.withValues(alpha: 0.08),
      child: Image.asset(Assets.testFood, fit: BoxFit.contain),
    );
  }
}
