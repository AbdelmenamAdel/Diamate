import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/lab_tests/presentation/managers/lab_test_cubit.dart';
import 'package:diamate/features/lab_tests/presentation/widgets/upload_lab_test_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => BlocProvider<LabTestCubit>(
                create: (context) => sl<LabTestCubit>(),
                child: const UploadLabTestBottomSheet(),
              ),
            );
          },
          icon: Icons.picture_as_pdf_rounded,
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
