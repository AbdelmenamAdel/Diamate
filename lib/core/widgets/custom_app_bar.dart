import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
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
    this.trailing,
  });
  final bool notification;
  final String title;
  final bool back;
  final void Function()? onTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        if (back)
          GestureDetector(
            onTap: onTap ?? () => Navigator.pop(context),
            child: Container(
              height: 42.h,
              width: 42.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: context.color.blackAndWhite!.withOpacity(0.1),
              ),
              child: Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: context.color.cardColor,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: context.color.textColor,
                ),
              ),
            ),
          ),
        Text(
          title,
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Spacer(),
        if (trailing != null) trailing!,
        if (notification) NotificationButton(),
      ],
    );
  }
}
