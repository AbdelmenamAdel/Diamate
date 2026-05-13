import 'dart:developer';

import 'package:diamate/constant.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/core/widgets/notification_button.dart';
import 'package:diamate/features/auth/presentation/managers/auth/auth_cubit.dart';
import 'package:diamate/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../views/widgets/daily_calory_card.dart';
import '../views/widgets/details_card.dart';
import '../views/widgets/recommeded_item.dart';
import '../views/widgets/quick_action_section.dart';
import 'package:diamate/features/food/presentation/managers/food_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is AuthAuthenticated,
      builder: (context, state) {
        final userName = context.read<AuthCubit>().user?.firstName;
        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $userName 👋',
                          style: TextStyle(
                            fontFamily: K.sg,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Here's your health overview for today",
                          style: TextStyle(
                            fontFamily: K.sg,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const NotificationButton(),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  hint: 'Search',
                  nodivider: true,
                  height: 48.h,
                  image: Assets.searchIcon,
                ),
                SizedBox(height: 16.h),

                // ! Daily Calory Section
                BlocBuilder<FoodCubit, FoodState>(
                  builder: (context, state) {
                    double totalCalories = 0;
                    double totalProtein = 0;
                    double totalCarbs = 0;
                    double totalFats = 0;

                    if (state is FoodHistoryLoaded) {
                      final now = DateTime.now();
                      final todayMeals =
                          state.meals[DateTime(now.year, now.month, now.day)] ??
                          [];
                      for (var meal in todayMeals) {
                        if (meal.nutrition != null) {
                          totalCalories += meal.nutrition!.calories;
                          totalProtein += meal.nutrition!.protein;
                          totalCarbs += meal.nutrition!.carbs;
                          totalFats += meal.nutrition!.fat;
                        }
                      }
                    }

                    return Column(
                      children: [
                        DailyCaloryCard(consumed: totalCalories),
                        SizedBox(height: 12.h),
                        DetailsCard(
                          protein: totalProtein,
                          carbs: totalCarbs,
                          fats: totalFats,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 24.h),
                // ! Recommended for you
                Text(
                  "Recommended for you",
                  style: TextStyle(
                    fontFamily: K.sg,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),

                Row(
                  children: [
                    const Expanded(child: RecommededItem()),
                    SizedBox(width: 8.w),
                    const Expanded(child: RecommededItem()),
                  ],
                ),
                SizedBox(height: 24.h),
                InkWell(
                  onTap: () async {
                    log("object");
                    await getData();
                  },
                  child: Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontFamily: K.sg,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                const QuickActionSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
