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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.h),
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
                ),
                BlocBuilder<RecommendedFoodCubit, RecommendedFoodState>(
                  builder: (context, rState) {
                    if (rState is RecommendedFoodLoading) {
                      return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    List<dynamic> recs = [];
                    if (rState is RecommendedFoodLoaded) {
                      recs = rState.recommendations;
                    }

                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.96 / 3,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                      ),
                      itemCount: recs.isNotEmpty ? recs.length : 2,
                      itemBuilder: (context, index) {
                        final meal = recs.isNotEmpty ? recs[index] : null;
                        return RecommededItem(meal: meal);
                      },
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
