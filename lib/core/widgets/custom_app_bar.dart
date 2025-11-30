import 'package:diamate/constant.dart';
import 'package:diamate/core/widgets/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.notification = true,
    required this.title,
    this.back = true,
    this.onTap,
  });
  final bool notification;
  final String title;
  final bool back;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        if (back)
          GestureDetector(
            onTap: onTap ?? () {},
            child: Container(
              height: 42.h,
              width: 42.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.black12,
              ),
              child: Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Icon(Icons.arrow_back_sharp),
              ),
            ),
          ),
        Text(
          title,
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        if (notification) NotificationButton(),
      ],
    );
  }
}
