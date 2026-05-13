import 'package:diamate/constant.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/language/app_Localizations.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/main/presentation/views/widgets/recommeded_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:diamate/features/food/presentation/managers/recommended_food_cubit.dart';

import '../widgets/food_scanner_bottom_sheet.dart';
import 'package:diamate/core/extensions/context_extension.dart';

import 'package:diamate/core/routes/app_routes.dart';

class FoodView extends StatelessWidget {
  const FoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          CustomAppBar(
            back: false,
            title: AppLocalizations.of(context)?.translate('food_log') ?? 'Food Log',
          ),

          CustomTextFormField(
            hint: 'Search',
            nodivider: true,
            height: 48.h,
            image: Assets.searchIcon,
          ),
          SizedBox(
            height: 44.h,
            child: Row(
              spacing: 8.w,
              children: [
                Expanded(
                  child: CustomButton(
                    radius: 8,
                    onTap: () {
                      context.pushNamed(AppRoutes.addFood);
                    },
                    text: AppLocalizations.of(context)?.translate('add_manually') ?? '+ Add Manually',
                    color: const Color(0xff2D9CDB),
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    radius: 8,
                    onTap: () async {
                      final result = await FoodScannerBottomSheet.show(context);
                      if (result != null && context.mounted) {
                        context.pushNamed(AppRoutes.addFood, arguments: result);
                      }
                    },
                    icon: const Icon(
                      size: 20,
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    text: AppLocalizations.of(context)?.translate('scan_food') ?? 'Scan Food',
                    color: const Color(0xff2D9CDB),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: CustomScrollView(
              slivers: [
                BlocBuilder<RecommendedFoodCubit, RecommendedFoodState>(
                  builder: (context, rState) {
                    // --- Header row with refresh button ---
                    final header = SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)?.translate('recommended_for_you') ?? 'Recommended for you',
                                style: TextStyle(
                                  fontFamily: K.sg,
                                  fontSize: 14,
                                  height: .5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: rState is RecommendedFoodLoading
                                  ? null
                                  : () => context.read<RecommendedFoodCubit>().refreshMeals(),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: rState is RecommendedFoodLoading
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: context.color.primaryColor,
                                        ),
                                      )
                                    : Icon(
                                        Icons.refresh_rounded,
                                        size: 20,
                                        color: context.color.primaryColor,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (rState is RecommendedFoodLoading) {
                      return SliverMainAxisGroup(
                        slivers: [
                          header,
                          const SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 48),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    if (rState is RecommendedFoodError) {
                      return SliverMainAxisGroup(
                        slivers: [
                          header,
                          SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 32),
                                child: Column(
                                  children: [
                                    Icon(Icons.wifi_off_rounded, size: 40, color: Colors.grey),
                                    const SizedBox(height: 8),
                                    Text(
                                      rState.message,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: K.sg, fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 12),
                                    TextButton.icon(
                                      onPressed: () => context.read<RecommendedFoodCubit>().refreshMeals(),
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: const Text("Try Again"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    List<dynamic> recs = [];
                    if (rState is RecommendedFoodLoaded) {
                      recs = rState.recommendations;
                    }

                    return SliverMainAxisGroup(
                      slivers: [
                        header,
                        SliverGrid.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 8.w,
                            mainAxisSpacing: 8.h,
                          ),
                          itemCount: recs.isNotEmpty ? recs.length : 4,
                          itemBuilder: (context, index) {
                            final meal = recs.isNotEmpty ? recs[index] : null;
                            return RecommededItem(meal: meal);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
