import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/lab_tests/presentation/managers/lab_test_cubit.dart';
import 'package:diamate/core/services/permission_service.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadLabTestBottomSheet extends StatefulWidget {
  const UploadLabTestBottomSheet({super.key});

  @override
  State<UploadLabTestBottomSheet> createState() =>
      _UploadLabTestBottomSheetState();
}

class _UploadLabTestBottomSheetState extends State<UploadLabTestBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  String? _filePath;
  String? _fileName;

  Future<void> _pickFile() async {
    final granted = await sl<PermissionService>().requestStoragePermission();

    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Storage permission is required to select files"),
          ),
        );
      }
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.color.primaryColor ?? Colors.blue;
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Upload Lab Test",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              fontFamily: K.sg,
              color: primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            "Enter a name and select your PDF file",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontFamily: K.sg,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          CustomTextFormField(
            hint: "Lab Test Name (e.g., Blood Test)",
            controller: _nameController,
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.picture_as_pdf_rounded,
                    color: primaryColor,
                    size: 28.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      _fileName ?? "Select PDF File",
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 14.sp,
                        color: _fileName != null
                            ? Colors.black
                            : Colors.grey[600],
                        fontWeight: _fileName != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_filePath != null)
                    Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                ],
              ),
            ),
          ),
          SizedBox(height: 32.h),
          CustomButton(
            onTap: () {
              if (_nameController.text.isNotEmpty && _filePath != null) {
                context.read<LabTestCubit>().addLabTest(
                  _nameController.text,
                  _filePath!,
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter a name and select a file"),
                  ),
                );
              }
            },
            text: "Upload Results",
          ),
        ],
      ),
    );
  }
}
