import 'dart:io';
import 'dart:ui' as ui;
import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_achievement_notification.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_test_cubit.dart';
import 'package:diamate/core/services/permission_service.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadDfuBottomSheet extends StatefulWidget {
  const UploadDfuBottomSheet({super.key});

  @override
  State<UploadDfuBottomSheet> createState() => _UploadDfuBottomSheetState();
}

class _UploadDfuBottomSheetState extends State<UploadDfuBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final granted = await sl<PermissionService>().requestPhotosPermission();

    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Storage permission is required to select images"),
          ),
        );
      }
      return;
    }

    final List<XFile> images = await _picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _imagePaths.addAll(images.map((e) => e.path));
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
      decoration: BoxDecoration(
        color: context.color.cardColor,
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
            "DFU Test (Foot Images)",
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
            "Enter a name and select foot ulcer images",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontFamily: K.sg,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          CustomTextFormField(
            hint: "Test Name (e.g., Left Foot Check)",
            controller: _nameController,
          ),
          SizedBox(height: 16.h),
          if (_imagePaths.isNotEmpty) ...[
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imagePaths.length + 1,
                itemBuilder: (context, index) {
                  if (index == _imagePaths.length) {
                    return GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 100.w,
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          color: primaryColor,
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      Container(
                        width: 100.w,
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: FileImage(File(_imagePaths[index])),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 12,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _imagePaths.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
          ],
          GestureDetector(
            onTap: _pickImages,
            child: CustomPaint(
              painter: DashedPainter(color: primaryColor),
              child: Container(
                height: 140.h,
                decoration: BoxDecoration(
                  color: (context.color.blackAndWhite ?? Colors.black)
                      .withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_rounded,
                      color: primaryColor,
                      size: 44.sp,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image_rounded,
                          color: primaryColor.withOpacity(0.8),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _imagePaths.isEmpty
                              ? "Upload Images"
                              : "${_imagePaths.length} Images Selected",
                          style: TextStyle(
                            fontFamily: K.sg,
                            fontSize: 16.sp,
                            color: _imagePaths.isNotEmpty
                                ? context.color.textColor
                                : Colors.grey[700],
                            fontWeight: _imagePaths.isNotEmpty
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
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
              if (_nameController.text.isNotEmpty && _imagePaths.isNotEmpty) {
                await context.read<DfuTestCubit>().addDfuTest(
                  _nameController.text,
                  _imagePaths,
                );

                if (mounted) {
                  Navigator.pop(context);
                  showAchievementView(
                    context: context,
                    title: "DFU Images Uploaded Successfully",
                    color: primaryColor,
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter a name and select images"),
                  ),
                );
              }
            },
            text: "Save Assessment",
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
      startX = 0;
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
