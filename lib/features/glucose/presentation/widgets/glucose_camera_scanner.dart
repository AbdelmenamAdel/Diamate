import 'dart:io';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class GlucoseCameraScanner extends StatefulWidget {
  const GlucoseCameraScanner({super.key});

  static Future<Map<String, dynamic>?> show(BuildContext context) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GlucoseCameraScanner(),
    );
  }

  @override
  State<GlucoseCameraScanner> createState() => _GlucoseCameraScannerState();
}

class _GlucoseCameraScannerState extends State<GlucoseCameraScanner> {
  XFile? _image;
  bool _isProcessing = false;
  String? _errorMessage;
  double? _detectedValue;

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _errorMessage = null;
        _detectedValue = null;
      });

      final XFile? image = await pickImage(source);

      if (image != null) {
        setState(() {
          _image = image;
        });
        await _processImage(image);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
    }
  }

  Future<void> _processImage(XFile image) async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // TODO: Integrate with your ML model here
      await Future.delayed(const Duration(seconds: 2));

      final simulatedValue = await _simulateGlucoseDetection(image);

      if (simulatedValue != null) {
        setState(() {
          _detectedValue = simulatedValue;
          _isProcessing = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Could not detect glucose reading. Please ensure the image is clear and shows a glucose meter display.';
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error processing image: $e';
        _isProcessing = false;
      });
    }
  }

  Future<double?> _simulateGlucoseDetection(XFile image) async {
    // TODO: Replace with actual ML model
    final random = DateTime.now().millisecond % 200 + 70;
    return random.toDouble();
  }

  void _retake() {
    setState(() {
      _image = null;
      _detectedValue = null;
      _errorMessage = null;
      _isProcessing = false;
    });
  }

  void _confirm() {
    if (_detectedValue != null && _image != null) {
      Navigator.of(
        context,
      ).pop({'value': _detectedValue, 'imagePath': _image!.path});
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
        child: SingleChildScrollView(
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
                      color: const Color(0xff45C588).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: const Color(0xff45C588),
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Scan Glucose Meter',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              if (_image == null) ...[
                // Empty state
                Container(
                  height: 240.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: const Color(0xff45C588).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          size: 48.sp,
                          color: const Color(0xff45C588),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Take a photo of your\nglucose meter',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Make sure the display is clear and visible',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Camera and Gallery buttons inline
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
                // Image preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.file(
                    File(_image!.path),
                    height: 240.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20.h),

                if (_isProcessing)
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: 12.h),
                        Text(
                          'Analyzing image...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Please wait',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.red.shade200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red.shade700,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detection Failed',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_detectedValue != null)
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff45C588).withOpacity(0.1),
                          const Color(0xff45C588).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xff45C588).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xff45C588),
                          size: 48.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Detected Value',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _detectedValue!.toInt().toString(),
                              style: TextStyle(
                                fontSize: 48.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff45C588),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'mg/dL',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _retake,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: Text(
                          'Retake',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (_detectedValue != null) ...[
                      SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          onTap: _confirm,
                          text: 'Confirm & Add',
                          color: const Color(0xff45C588),
                          radius: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
