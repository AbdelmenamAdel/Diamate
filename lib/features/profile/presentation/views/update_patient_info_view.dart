import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/auth/presentation/managers/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdatePatientInfoView extends StatefulWidget {
  const UpdatePatientInfoView({super.key});

  @override
  State<UpdatePatientInfoView> createState() => _UpdatePatientInfoViewState();
}

class _UpdatePatientInfoViewState extends State<UpdatePatientInfoView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  void _loadCurrentData() {
    final user = context.read<AuthCubit>().user;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _weightController.text = user.weight.toString();
      _heightController.text = user.height.toString();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _updatePatientInfo() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Connect to AuthCubit when backend endpoint is ready
    await Future.delayed(const Duration(seconds: 1)); // Mock delay

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Patient information updated successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              const CustomAppBar(
                title: "Update Information",
                back: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        controller: _firstNameController,
                        hint: "First Name",
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        controller: _lastNameController,
                        hint: "Last Name",
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        controller: _emailController,
                        hint: "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        controller: _phoneController,
                        hint: "Phone Number",
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: _weightController,
                              hint: "Weight (kg)",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: CustomTextFormField(
                              controller: _heightController,
                              hint: "Height (cm)",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              onTap: _updatePatientInfo,
                              text: "Save Changes",
                              color: context.color.primaryColor,
                            ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
