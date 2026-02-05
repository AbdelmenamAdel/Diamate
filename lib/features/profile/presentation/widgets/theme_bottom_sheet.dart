import 'package:diamate/core/app/app_cubit/app_cubit.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Current active theme from Cubit
    final currentTheme = context.watch<AppCubit>().appTheme;

    final themeOptions = [
      {
        'mode': ThemeEnum.light,
        'name': 'Light Mode',
        'icon': Icons.wb_sunny_rounded,
        'desc': 'Bright and clear interface.',
      },
      {
        'mode': ThemeEnum.dark,
        'name': 'Dark Mode',
        'icon': Icons.nightlight_round,
        'desc': 'Easy on the eyes at night.',
      },
      {
        'mode': ThemeEnum.system,
        'name': 'System Default',
        'icon': Icons.phone_android_rounded,
        'desc': 'Follows your device settings.',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.color.containerColor, // Adapts to current themes
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 24.h),

          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.palette_rounded,
                  color: Colors.purple,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Appearance',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SpaceGrotesk',
                      color: context.color.textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Choose your preferred visual style.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Options List
          ...themeOptions.map((option) {
            final mode = option['mode'] as ThemeEnum;
            final isSelected = currentTheme == mode;

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: InkWell(
                onTap: () {
                  context.read<AppCubit>().changeAppThemeMode(
                    selectedMode: mode,
                  );
                  context.pop();
                },
                borderRadius: BorderRadius.circular(16.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.color.primaryColor!.withOpacity(0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? context.color.primaryColor!
                          : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option['icon'] as IconData,
                        color: isSelected
                            ? context.color.primaryColor
                            : Colors.grey,
                        size: 24.sp,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['name'] as String,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SpaceGrotesk',
                                color: context.color.textColor,
                              ),
                            ),
                            Text(
                              option['desc'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontFamily: 'SpaceGrotesk',
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: context.color.primaryColor,
                          size: 24.sp,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
