import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/auth/presentation/views/widgets/have_no_acc_q.dart';
import 'package:diamate/features/auth/presentation/views/widgets/social_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(child: Image.asset(Assets.bgImgLogin)),
          Positioned.fill(
            child: Image.asset(Assets.gradientBg, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 24.0 + 240.h,
              left: 24.0,
              right: 24.0,
            ),
            child: Column(
              children: [
                Text(
                  "Hello there,",
                  style: TextStyle(
                    fontFamily: K.sg,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  "Eat better. Get back on track.",
                  style: TextStyle(
                    fontFamily: K.sg,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
                const SizedBox(height: 24),
                const CustomTextFormField(hint: 'UserName'),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hint: "Password",
                  validator: (value) {
                    if (value != null && value.length > 7) {
                      return "enter a valid password";
                    }
                    return null;
                  },
                  onChanged: (value) {},
                  image: Assets.lockPassword,
                ),
                SizedBox(height: 16),
                CustomButton(
                  onTap: () {
                    context.pushNamedAndRemoveUntil(AppRoutes.main);
                  },
                  text: "Login",
                ),
                SizedBox(height: 16),
                SocialBtn(),
              ],
            ),
          ),
          HaveNoAccQ(),
        ],
      ),
    );
  }
}
