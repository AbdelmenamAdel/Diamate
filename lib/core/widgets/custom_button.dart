import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/text/text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.text,
    this.icon,
    this.color,
    this.isLoading = false,
    this.textColor,
    this.radius,
  });

  final void Function()? onTap;
  final Widget? icon;
  final String text;
  final Color? color;
  final bool isLoading;
  final Color? textColor;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 400.w, // الحد الأقصى للعرض
      ),
      child: InkWell(
        onTap: isLoading ? null : onTap, // ممنوع الضغط وقت التحميل
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color ?? context.color.primaryColor,
            borderRadius: BorderRadius.circular(radius ?? 16),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 24.h,
                    width: 24.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) icon!,
                      if (icon != null) SizedBox(width: 8.w),
                      Text(
                        text,
                        style: TextStyles.regular14.copyWith(
                          color: textColor ?? Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: K.sg,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
