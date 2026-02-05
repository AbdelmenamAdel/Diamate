import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';

import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/core/widgets/custom_achievement_notification.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_date_picker.dart';
import 'package:diamate/core/widgets/custom_image_picker.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/auth/domain/entites/user_entity.dart';
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
  final TextEditingController _phoneHomeCtrl = TextEditingController();
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
  AutovalidateMode autoValidatorMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _phoneHomeCtrl.dispose();
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

  Future<void> _next(BuildContext context) async {
    bool isValid = false;
    if (_step == 0) {
      if (_formKey1.currentState!.validate()) {
        isValid = true;
      } else {
        setState(() {
          autoValidatorMode = AutovalidateMode.always;
        });
      }
    } else if (_step == 1) {
      if (_formKey2.currentState!.validate()) {
        isValid = true;
      } else {
        setState(() {
          autoValidatorMode = AutovalidateMode.always;
        });
      }
    }

    if (isValid && _step < 2) {
      setState(() {
        _step++;
        autoValidatorMode = AutovalidateMode.disabled;
      });

      _pageController.animateToPage(
        _step,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else if (_step == 2) {
      if (_formKey3.currentState!.validate()) {
        // Triggering registration via Cubit (as example)
        final String base64Image = await assetImageToBase64(Assets.men3em);
        final user = UserEntity(
          firstName: _nameCtrl.text,
          secondName: _lastNameCtrl.text,
          thirdName: '',
          lastName: '',
          phone: _phoneCtrl.text,
          userName: _usernameCtrl.text,
          password: _passwordCtrl.text,
          dateOfBirth: _dobCtrl.text,
          gender: _gender == "Male" ? 0 : 1,
          address: "", // to be added later and it accept null
          email: _emailCtrl.text,
          profileImage: base64Image,
          weight: int.parse(_weightCtrl.text),
          // height: int.parse(_heightCtrl.text),
          // diabetesType: _diabetes,
          // diagnosisDate: _diagnosisDateCtrl.text,
        );
        // login accout to try
        // joooo - 1234yY@
        context.read<AuthCubit>().register(user: user);
      } else {
        setState(() {
          autoValidatorMode = AutovalidateMode.always;
        });
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

  Widget _stepOne(BuildContext context) {
    return Form(
      key: _formKey1,
      autovalidateMode: autoValidatorMode,
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
              hint: 'Home Phone number',
              image: Assets.phone,
              controller: _phoneHomeCtrl,
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
              readOnly: true,
              onTap: () async {
                await pickDate(context, _dobCtrl);
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }

                return null;
              },
            ),
            SizedBox(height: 16.h),
            CustomButton(onTap: () => _next(context), text: 'Next'),
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

  Widget _stepTwo(BuildContext context) {
    return Form(
      key: _formKey2,
      autovalidateMode: autoValidatorMode,
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
              readOnly: true,
              onTap: () async {
                await pickDate(context, _diagnosisDateCtrl);
                setState(() {});
              },
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
                      if (double.parse(value) < 40 ||
                          double.parse(value) > 250) {
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
                      if (double.parse(value) < 60 ||
                          double.parse(value) > 250) {
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
                  child: CustomButton(
                    onTap: () => _next(context),
                    text: 'Next',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepThree(BuildContext context) {
    return Form(
      key: _formKey3,
      autovalidateMode: autoValidatorMode,
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
                if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
                  return 'Need at least 1 number';
                }
                if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                  return 'Need at least 1 uppercase';
                }
                if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                  return 'Need at least 1 lowercase';
                }
                if (!RegExp(r'(?=.*[!@#\$&*~])').hasMatch(value)) {
                  return 'Need special char (!@#\$&*~)';
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
            CustomButton(onTap: () => _next(context), text: 'Sign Up'),
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
    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            SecureStorage.setBoolean(key: K.isLogged, value: true);
            showAchievementView(
              context: context,
              color: context.color.primaryColor,
              title: 'Account Created Successfully!',
            );
            // Navigate to chatbots or home
            context.pushNamedAndRemoveUntil(AppRoutes.chatbot);
          } else if (state is RegisterFailure) {
            showAchievementView(
              context: context,
              color: Colors.red,
              title: state.message,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
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
                          minHeight:
                              MediaQuery.of(context).size.height - bottomInset,
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
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Disable swipe
                                  children: [
                                    _stepOne(context),
                                    _stepTwo(context),
                                    _stepThree(context),
                                  ],
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
              if (state is RegisterLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
