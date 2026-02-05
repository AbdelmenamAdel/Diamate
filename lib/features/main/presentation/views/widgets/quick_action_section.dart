import 'package:diamate/core/generated/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'quick_action.dart';

class QuickActionSection extends StatelessWidget {
  const QuickActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      children: [
        QuickActionWidget(
          color: Color(0xff5F0095),
          text: "Add Drug",
          image: Assets.medicine,
          onTap: () {},
        ),
        QuickActionWidget(
          color: Color(0xff1DC500),
          text: "Lab Test",
          onTap: () {},
          icon: Icons.file_copy_rounded,
        ),
        QuickActionWidget(
          color: Color(0xffDD6400),
          text: "DFU Test",
          onTap: () {},
          icon: Icons.image_rounded,
        ),
      ],
    );
  }
}
