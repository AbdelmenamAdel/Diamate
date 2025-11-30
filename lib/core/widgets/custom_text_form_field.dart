import 'package:diamate/constant.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 1, color: Color(0xffE4E4E4)),
        borderRadius: BorderRadius.circular(16),
      ),
      height: height ?? 56.h,
      child: Row(
        children: [
          imagepng == null
              ? SvgPicture.asset(image ?? Assets.vector)
              : Image.asset(height: 16, width: 16, imagepng!),
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
                color: Colors.black,
                fontSize: 12.sp,
              ),
              cursorColor: Colors.black.withOpacity(.65),
              keyboardType: keyboardType,
              validator: validator,
              controller: controller,
              onSaved: onSaved,
              obscureText: obscureText,
              obscuringCharacter: '*',
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: K.sg,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: Colors.black,
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
