import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/food/presentation/managers/recommended_food_cubit.dart';
import 'package:diamate/features/main/presentation/views/widgets/recommeded_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedMealsView extends StatelessWidget {
  const SavedMealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(back: true, title: 'Saved Meals'),
            Expanded(
              child: BlocBuilder<RecommendedFoodCubit, RecommendedFoodState>(
                builder: (context, state) {
                  if (state is RecommendedFoodLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<dynamic> meals = [];
                  if (state is RecommendedFoodLoaded) {
                    meals = state.savedMeals;
                  }

                  if (meals.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 64.sp,
                            color: context.color.hintColor?.withOpacity(0.4),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "لا توجد وجبات محفوظة حالياً",
                            style: TextStyle(
                              fontFamily: K.sg,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: context.color.textColor?.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "احفظ أي وجبة تعجبك للرجوع إليها لاحقاً",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: context.color.hintColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.96 / 3,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      return RecommededItem(meal: meals[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
