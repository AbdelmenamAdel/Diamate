// ! ????????????????????????????????????????????????????????????
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/features/food/presentation/views/food_view.dart';
import 'package:diamate/features/main/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    HomeView(),
    FoodView(),
    SizedBox(),
    Scaffold(),
    Scaffold(),
  ];

  void _navigate() {
    context.pushNamed(AppRoutes.chatbot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
      bottomNavigationBar: SizedBox(
        height: 92.h,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12.r,
                offset: Offset(0, -4.h),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Assets.home, 'Home'),
              _navItem(1, Assets.food, 'Food'),
              _navItem(2, Assets.aiLogo, null),
              _navItem(3, Assets.ruler, 'Glucose'),
              _navItem(4, Assets.vector, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, String asset, String? label) {
    final bool active = _currentIndex == index;
    final color = active
        ? const Color(0xFF2EA6F2)
        : Colors.black.withOpacity(.6);
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _currentIndex = index);
          if (_currentIndex == 2) _navigate();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index != 2)
              SvgPicture.asset(asset, color: color, width: 22.w, height: 22.h),
            if (index == 2)
              Container(
                height: 56.h,
                width: 56.h,
                // margin: EdgeInsets.only(bottom: 12),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image.asset(
                  asset,
                  width: 36.w,
                  height: 36.h,
                  fit: BoxFit.cover,
                ),
              ),
            if (label != null) SizedBox(height: 8.h),
            if (label != null)
              Text(
                label,
                style: TextStyle(color: color, fontSize: 12.sp),
              ),
          ],
        ),
      ),
    );
  }
}
