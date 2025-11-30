import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/widgets/custom_achievement_notification.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/auth/presentation/views/widgets/have_acc_q.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  int _step = 0;

  // Step 1
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();

  // Step 2
  String _gender = '';
  String _diabetes = 'Type 1';
  final TextEditingController _diagnosisDateCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();

  // Step 3
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPwdCtrl = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _diagnosisDateCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 2) {
      setState(() {
        _step++;
      });

      _pageController.animateToPage(
        _step,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      showAchievementView(
        context: context,
        color: context.color.primaryColor,
        title: 'Signup complete (mock)',
      );
      context.pushNamedAndRemoveUntil(AppRoutes.chatbot);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() {
        _step--;
      });

      _pageController.animateToPage(
        _step,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Hello there,',
          style: TextStyle(
            fontFamily: K.sg,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Create Your DiaMate Account',
          style: TextStyle(
            fontFamily: K.sg,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _stepOne() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(
            height: 56.h,

            child: Row(
              spacing: 8.h,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hint: 'First Name',
                    controller: _nameCtrl,
                  ),
                ),
                Expanded(
                  child: CustomTextFormField(
                    hint: 'Last Name',
                    controller: _nameCtrl,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 56.h,

            child: Row(
              spacing: 8.h,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hint: 'First Name',
                    controller: _nameCtrl,
                  ),
                ),
                Expanded(
                  child: CustomTextFormField(
                    hint: 'Last Name',
                    controller: _nameCtrl,
                  ),
                ),
              ],
            ),
          ),

          // SizedBox(height: 16.h),
          // CustomTextFormField(
          //   hint: 'Phone number',
          //   image: Assets.phone,
          //   controller: _phoneCtrl,
          // ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            hint: 'Date of birth',
            image: Assets.calendarDate,
            controller: _dobCtrl,
          ),
          SizedBox(height: 16.h),
          CustomButton(onTap: _next, text: 'Next'),
          SizedBox(height: 16.h),
          // SocialBtn(),
        ],
      ),
    );
  }

  Widget _genderChip(String label, IconData icon) {
    final bool selected = _gender == label;
    return GestureDetector(
      onTap: () => setState(() => _gender = label),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: selected ? Colors.grey[300] : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp),
            SizedBox(width: 8.w),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _diabetesChip(String label) {
    final bool selected = _diabetes == label;
    return GestureDetector(
      onTap: () => setState(() => _diabetes = label),
      child: Container(
        // height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? Colors.grey[300] : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(label)],
        ),
      ),
    );
  }

  Widget _stepTwo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 56.h,
            child: Column(
              children: [
                Row(
                  spacing: 12.w,
                  children: [
                    Expanded(child: _genderChip('Male', Icons.male)),
                    Expanded(child: _genderChip('Female', Icons.female)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Diabetes type',
            style: TextStyle(fontWeight: FontWeight.w600, fontFamily: K.sg),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            // height: 56.h,
            child: Column(
              spacing: 12.w,

              children: [
                Row(
                  spacing: 12.w,
                  children: [
                    Expanded(child: _diabetesChip('Type 1')),
                    Expanded(child: _diabetesChip('Type 2')),
                  ],
                ),
                Row(
                  spacing: 12.w,

                  children: [
                    Expanded(child: _diabetesChip('Prediabetes')),
                    Expanded(child: _diabetesChip('Gestational')),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          CustomTextFormField(
            hint: 'Date of Diagnosis',
            image: Assets.calendarDate,
            controller: _diagnosisDateCtrl,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  hint: 'Weight',
                  image: Assets.weight,
                  controller: _weightCtrl,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextFormField(
                  hint: 'Height',
                  imagepng: Assets.height,
                  controller: _heightCtrl,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: _back,
                  text: 'Back',
                  color: Color(0xffEDEDED),
                  textColor: Colors.black54,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(onTap: _next, text: 'Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepThree() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextFormField(hint: 'UserName', controller: _usernameCtrl),
          SizedBox(height: 12.h),
          CustomTextFormField(
            hint: 'Email',
            controller: _emailCtrl,
            image: Assets.email,
          ),
          SizedBox(height: 12.h),
          CustomTextFormField(
            hint: 'Password',
            controller: _passwordCtrl,
            obscureText: true,
            image: Assets.lockPassword,
          ),
          SizedBox(height: 12.h),
          CustomTextFormField(
            hint: 'Confirm Password',
            controller: _confirmPwdCtrl,
            obscureText: true,
            image: Assets.lockPassword,
          ),
          SizedBox(height: 16.h),
          CustomButton(onTap: _next, text: 'Sign Up'),
          SizedBox(height: 16.h),
          // SocialBtn(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(child: Image.asset(Assets.bgImgLogin)),
          Positioned.fill(
            child: Image.asset(Assets.gradientBg, fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 240.h),
                SizedBox(height: 24),

                _buildHeader(),
                SizedBox(
                  height: 450.h, // لازم نحدد ارتفاع للـ PageView
                  child: PageView(
                    controller: _pageController, // اعمل PageController فوق
                    onPageChanged: (index) {
                      setState(() => _step = index);
                    },
                    children: [_stepOne(), _stepTwo(), _stepThree()],
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 28.h),
              child: HaveAccQ(),
            ),
          ),
        ],
      ),
    );
  }
}
