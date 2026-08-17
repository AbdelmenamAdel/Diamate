import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New passwords do not match")),
      );
      return;
    }

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
        const SnackBar(content: Text("Password changed successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: context.color.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Change Password",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: context.color.textColor,
              ),
            ),
            SizedBox(height: 24.h),
            CustomTextFormField(
              controller: _currentPasswordController,
              hint: "Current Password",
              obscureText: true,
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              controller: _newPasswordController,
              hint: "New Password",
              obscureText: true,
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              controller: _confirmPasswordController,
              hint: "Confirm New Password",
              obscureText: true,
            ),
            SizedBox(height: 32.h),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    onTap: _changePassword,
                    text: "Update Password",
                    color: context.color.primaryColor,
                  ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
