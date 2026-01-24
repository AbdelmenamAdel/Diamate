import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';

import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/core/widgets/custom_achievement_notification.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/auth/presentation/managers/auth/auth_cubit.dart';
import 'package:diamate/features/auth/presentation/views/widgets/have_acc_q.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();

  // Step 2
  String _gender = 'Male';
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

  // Form Validation
  // Form Validation
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final AutovalidateMode _autoValidatorMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
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
    bool isValid = false;
    if (_step == 0) {
      if (_formKey1.currentState!.validate()) isValid = true;
    } else if (_step == 1) {
      if (_formKey2.currentState!.validate()) isValid = true;
    }

    if (isValid && _step < 2) {
      setState(() {
        _step++;
      });

      _pageController.animateToPage(
        _step,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else if (_step == 2) {
      if (_formKey3.currentState!.validate()) {
        showAchievementView(
          context: context,
          color: context.color.primaryColor,
          title: 'Signup complete (mock)',
        );

        // Implement actual registration logic calls here or in proper place
        // For now preventing context.push to allow validator verification visually
        // context.pushNamedAndRemoveUntil(AppRoutes.chatbot);

        // Triggering registration via Cubit (as example)
        // context.read<AuthCubit>().register(user: ...);
      }
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
    return Form(
      key: _formKey1,
      child: Padding(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      hint: 'Last Name',
                      controller: _lastNameCtrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              hint: 'Phone number',
              image: Assets.phone,
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (value.length < 10) {
                  return 'Invalid Phone';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              hint: 'Date of birth',
              image: Assets.calendarDate,
              controller: _dobCtrl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomButton(onTap: _next, text: 'Next'),
            SizedBox(height: 16.h),
            // SocialBtn(),
          ],
        ),
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
    return Form(
      key: _formKey2,
      child: Padding(
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hint: 'Weight',
                    image: Assets.weight,
                    controller: _weightCtrl,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomTextFormField(
                    hint: 'Height',
                    imagepng: Assets.height,
                    controller: _heightCtrl,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid';
                      }
                      return null;
                    },
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
      ),
    );
  }

  Widget _stepThree() {
    return Form(
      key: _formKey3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              hint: 'UserName',
              controller: _usernameCtrl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            CustomTextFormField(
              hint: 'Email',
              controller: _emailCtrl,
              image: Assets.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                ).hasMatch(value)) {
                  return 'Invalid Email';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            CustomTextFormField(
              hint: 'Password',
              controller: _passwordCtrl,
              obscureText: true,
              image: Assets.lockPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (value.length < 8) {
                  return 'Min 8 chars';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),
            CustomTextFormField(
              hint: 'Confirm Password',
              controller: _confirmPwdCtrl,
              obscureText: true,
              image: Assets.lockPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (value != _passwordCtrl.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomButton(onTap: _next, text: 'Sign Up'),
            SizedBox(height: 16.h),
            // SocialBtn(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom / 4;
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(child: Image.asset(Assets.bgImgLogin)),
            Positioned.fill(
              child: Image.asset(Assets.gradientBg, fit: BoxFit.cover),
            ),
            // Use a scrollable layout that respects the keyboard inset
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: bottomInset + 24, // extra space for keyboard
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - bottomInset,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 240.h),
                    SizedBox(height: 24),
                    _buildHeader(),
                    // Wrap PageView with padding to account for keyboard
                    Padding(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: SizedBox(
                        height: 450.h, // لازم نحدد ارتفاع للـ PageView
                        child: PageView(
                          controller:
                              _pageController, // اعمل PageController فوق
                          onPageChanged: (index) {
                            setState(() => _step = index);
                          },
                          children: [_stepOne(), _stepTwo(), _stepThree()],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: bottomInset > 0 ? bottomInset + 16.h : 16.h,
                ),
                child: HaveAccQ(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
