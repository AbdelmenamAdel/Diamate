import 'package:diamate/constant.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlucoseView extends StatelessWidget {
  const GlucoseView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12.h,
          children: [
            CustomAppBar(back: false, title: "Glucose Monitor"),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "125",
                  style: TextStyle(
                    fontFamily: K.sg,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  " mg/dL",
                  style: TextStyle(
                    fontFamily: K.sg,
                    fontSize: 20,
                    color: Color(0xff838572),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            Text(
              "Normal",
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 18,
                color: Color(0xff45C588),
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Updated 5 min ago",
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 12,
                color: Color(0xff010101).withOpacity(.6),
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(
              height: 44.h,
              // width: 160.w,
              child: false
                  ? CustomButton(
                      radius: 8,
                      onTap: () {},
                      text: "+ Add Manually",
                      color: Color(0xff2D9CDB),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        spacing: 8.w,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Spacer(),
                          Expanded(
                            flex: 3,
                            child: CustomButton(
                              radius: 8,
                              onTap: () {},
                              text: "125 mg/dL",
                              color: Color(0xff010101).withOpacity(.38),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomButton(
                              radius: 8,
                              onTap: () {},
                              text: "insert",
                              color: Color(0xff2D9CDB),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.w,
              children: [
                GlucoseLevel(level: "High", value: 260),
                GlucoseLevel(level: "Avarage", value: 170, isAvarage: true),
                GlucoseLevel(level: "Low", value: 80),
              ],
            ),
            Container(
              height: 300,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlucoseLevel extends StatelessWidget {
  const GlucoseLevel({
    super.key,
    required this.level,
    required this.value,
    this.isAvarage = false,
  });
  final String level;
  final double value;
  final bool isAvarage;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text(
            level,
            style: TextStyle(
              fontSize: 16,
              fontFamily: K.sg,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontFamily: K.sg,
              color: isAvarage ? Color(0xff45C588) : Color(0xffF25661),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "mg/dL",
            style: TextStyle(
              fontSize: 10,
              fontFamily: K.sg,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
