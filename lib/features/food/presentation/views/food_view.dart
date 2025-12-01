import 'package:diamate/constant.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/main/presentation/views/widgets/recommeded_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodView extends StatelessWidget {
  const FoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          CustomAppBar(back: false, title: 'Food Log'),

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
                    onTap: () {},
                    text: "+ Add Manually",
                    color: Color(0xff2D9CDB),
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    radius: 8,
                    onTap: () {},
                    icon: Icon(
                      size: 20,
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                    text: "Scan Food",
                    color: Color(0xff2D9CDB),
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
                      "Recommended for you",
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 14,
                        height: .5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return RecommededItem();
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
