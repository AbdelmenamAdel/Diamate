import 'dart:ui' as ui;
import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_achievement_notification.dart';
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
            child: CustomPaint(
              painter: DashedPainter(color: primaryColor),
              child: Container(
                height: 140.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF8F9FA),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_rounded,
                      color: primaryColor,
                      size: 44.sp,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.picture_as_pdf_rounded,
                          color: primaryColor.withOpacity(0.8),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            _fileName ?? "Upload PDF Report",
                            style: TextStyle(
                              fontFamily: K.sg,
                              fontSize: 16.sp,
                              color: _fileName != null
                                  ? Colors.black
                                  : Colors.grey[700],
                              fontWeight: _fileName != null
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          CustomButton(
            onTap: () async {
              if (_nameController.text.isNotEmpty && _filePath != null) {
                await context.read<LabTestCubit>().addLabTest(
                  _nameController.text,
                  _filePath!,
                );

                if (mounted) {
                  Navigator.pop(context);
                  showAchievementView(
                    context: context,
                    title: "Lab Test Uploaded Successfully",
                    color: primaryColor,
                  );
                }
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

class DashedPainter extends CustomPainter {
  final Color color;
  DashedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8, dashSpace = 4, startX = 0;
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(24.r),
        ),
      );

    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      startX =
          0; // Reset startX for each metric to ensure it starts from the beginning of the path
      while (startX < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(startX, startX + dashWidth),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
