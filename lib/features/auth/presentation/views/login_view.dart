import 'dart:developer';

import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/core/styles/theme/app_theme.dart';
import 'package:diamate/core/widgets/custom_achievement_notification.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/auth/presentation/managers/auth/auth_cubit.dart';
import 'package:diamate/features/auth/presentation/views/widgets/have_no_acc_q.dart';
import 'package:diamate/features/auth/presentation/views/widgets/social_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ارتفاع الكيبورد (0 لو مفيش كيبورد)
    final bottomInset = MediaQuery.of(context).viewInsets.bottom / 6;

    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>(),
      child: Theme(
        data: themeLight(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                showAchievementView(
                  context: context,
                  title: state.message,
                  color: Colors.red,
                );
              } else if (state is LoginSuccess) {
                SecureStorage.setBoolean(key: K.isLogged, value: true);
                context.pushNamedAndRemoveUntil(AppRoutes.chatbot);
                showAchievementView(
                  context: context,
                  title: "Login Success",
                  color: context.color.primaryColor,
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  // الخلفية تملى الشاشة كلها
                  SizedBox(
                    child: Image.asset(Assets.bgImgLogin, fit: BoxFit.cover),
                  ),
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
                      child: Form(
                        key: _formKey,
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
                            CustomTextFormField(
                              hint:
                                  'UserName', // Changed from Email to UserName as per UI, but usually it's email. Assuming 'email' for auth logic based on cubit.
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormField(
                              hint: "Password",
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return "enter a valid password";
                                }
                                return null;
                              },
                              image: Assets.lockPassword,
                              obscureText:
                                  true, // Assuming password should be obscured
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              onTap: () {
                                log(_emailController.text);
                                log(_passwordController.text);
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                }
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
                  if (state is LoginLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
