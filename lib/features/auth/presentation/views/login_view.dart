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
    // ارتفاع الكيبورد (0 لو مفيش كيبورد)
    final bottomInset = MediaQuery.of(context).viewInsets.bottom / 6;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // الخلفية تملى الشاشة كلها
          SizedBox(child: Image.asset(Assets.bgImgLogin, fit: BoxFit.cover)),
          Positioned.fill(
            child: Image.asset(Assets.gradientBg, fit: BoxFit.cover),
          ),

          // الفورم في النص تقريبًا + Scroll
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              bottomInset + 24, // Adjust bottom padding for keyboard
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Do not subtract bottomInset to keep the content centered in the full screen
                // instead of shifting up when keyboard opens.
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
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
                      if (value == null || value.length < 8) {
                        return "enter a valid password";
                      }
                      return null;
                    },
                    onChanged: (value) {},
                    image: Assets.lockPassword,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    onTap: () {
                      context.pushNamedAndRemoveUntil(AppRoutes.chatbot);
                    },
                    text: "Login",
                  ),
                  const SizedBox(height: 16),
                  const SocialBtn(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // HaveNoAccQ ثابت تحت، ولما الكيبورد تطلع يطلع فوقها شوية
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: bottomInset > 0 ? bottomInset + 16 : 16,
              ),
              child: const HaveNoAccQ(),
            ),
          ),
        ],
      ),
    );
  }
}
