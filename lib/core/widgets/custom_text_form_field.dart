import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/styles/text/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hint,
    this.image,
    this.height,
    this.imagepng,
    this.onSaved,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.nodivider = false,
    this.obscureText = false,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.suffix,
  });

  final String hint;
  final String? imagepng;
  final String? image;
  final double? height;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final bool obscureText;
  final bool nodivider;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: context.color.containerColor ?? const Color(0xffE4E4E4),
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      height: height ?? 56.h,
      child: Row(
        children: [
          imagepng == null
              ? SvgPicture.asset(
                  image ?? Assets.vector,
                  color: context.color.textColor,
                )
              : Image.asset(
                  height: 16,
                  width: 16,
                  imagepng!,
                  color: context.color.textColor,
                ),
          if (!nodivider)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                width: 1,
                height: 32.h,
                color: Color(0xffE4E4E4),
              ),
            ),
          Expanded(
            child: TextFormField(
              style: TextStyles.regular14.copyWith(
                color: context.color.textColor,
                fontSize: 12.sp,
              ),
              cursorColor: context.color.textColor?.withOpacity(.65),
              keyboardType: keyboardType,
              validator: validator,
              controller: controller,
              onSaved: onSaved,
              obscureText: obscureText,
              obscuringCharacter: '*',
              onChanged: onChanged,
              onTap: onTap,
              readOnly: readOnly,
              decoration: InputDecoration(
                suffix: suffix,
                suffixIconColor: context.color.textColor,
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: K.sg,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: context.color.textColor,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
