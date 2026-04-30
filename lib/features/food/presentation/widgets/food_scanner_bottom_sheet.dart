import 'dart:io';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../managers/food_cubit.dart';

class FoodScannerBottomSheet extends StatefulWidget {
  const FoodScannerBottomSheet({super.key});

  static Future<List<String>?> show(BuildContext context) {
    final foodCubit = context.read<FoodCubit>();
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: foodCubit,
        child: const FoodScannerBottomSheet(),
      ),
    );
  }

  @override
  State<FoodScannerBottomSheet> createState() => _FoodScannerBottomSheetState();
}

class _FoodScannerBottomSheetState extends State<FoodScannerBottomSheet> {
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await pickImage(source);
    if (image != null) {
      setState(() {
        _image = image;
      });
      if (mounted) {
        context.read<FoodCubit>().analyzeImage(File(image.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BlocConsumer<FoodCubit, FoodState>(
          listener: (context, state) {
            // We removed the immediate pop to show results in UI
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Title
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xff2D9CDB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: const Color(0xff2D9CDB),
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        state is FoodAnalysisSuccess
                            ? 'Results'
                            : 'Scan Your Meal',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  if (_image == null) ...[
                    // Selection buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () => _pickImage(ImageSource.camera),
                            text: 'Camera',
                            color: const Color(0xff45C588),
                            radius: 12,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomButton(
                            onTap: () => _pickImage(ImageSource.gallery),
                            text: 'Gallery',
                            color: const Color(0xff2D9CDB),
                            radius: 12,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Preview and status
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.file(
                            File(_image!.path),
                            height: 200.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (state is! FoodAnalysisLoading)
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    if (state is FoodAnalysisLoading)
                      Column(
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xff2D9CDB),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Analyzing ingredients...',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      )
                    else if (state is FoodAnalysisSuccess)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Detected Ingredients:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: state.ingredients.map((ing) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xff2D9CDB).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                      color: const Color(0xff2D9CDB)
                                          .withOpacity(0.3)),
                                ),
                                child: Text(
                                  ing,
                                  style: TextStyle(
                                    color: const Color(0xff2D9CDB),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 32.h),
                          CustomButton(
                            onTap: () {
                              Navigator.of(context).pop(state.ingredients);
                            },
                            text: 'Confirm & Add Meal',
                            color: const Color(0xff2D9CDB),
                            radius: 12,
                          ),
                        ],
                      )
                    else if (state is FoodError)
                      Container(
                        padding: EdgeInsets.all(16.w),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Text(
                              state.message,
                              style: TextStyle(color: Colors.red.shade700),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              child: const Text("Try another image"),
                            ),
                          ],
                        ),
                      ),
                  ],
                  SizedBox(height: 8.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
