import 'package:diamate/constant.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/core/widgets/notification_button.dart';
import 'package:diamate/features/main/presentation/views/widgets/details_card.dart';
import 'package:diamate/features/main/presentation/views/widgets/recommeded_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/daily_calory_card.dart';
import 'widgets/quick_action_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Abdelmoneim 👋',
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Here's your health overview for today",
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                NotificationButton(),
              ],
            ),
            SizedBox(height: 16.h),

            CustomTextFormField(
              hint: 'Search',
              nodivider: true,
              height: 48.h,
              image: Assets.searchIcon,
            ),
            SizedBox(height: 12.h),
            // ! Daily Calory Section
            DailyCaloryCard(),
            // ! End of Daily Calory Section
            SizedBox(height: 12.h),
            DetailsCard(),
            SizedBox(height: 12.h),
            // ! Recommeded for you
            Text(
              "Recommended for you",
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),

            Row(
              spacing: 8.w,
              children: [
                Expanded(child: RecommededItem()),
                Expanded(child: RecommededItem()),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "Quick Actions",
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            QuickActionSection(),
          ],
        ),
      ),
    );
  }
}
