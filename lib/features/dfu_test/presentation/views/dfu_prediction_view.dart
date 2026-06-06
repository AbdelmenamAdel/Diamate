import 'dart:convert';
import 'dart:io';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_test_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_prediction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class DfuPredictionView extends StatefulWidget {
  const DfuPredictionView({super.key});

  @override
  State<DfuPredictionView> createState() => _DfuPredictionViewState();
}

class _DfuPredictionViewState extends State<DfuPredictionView> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        if (mounted) {
          context.read<DfuPredictionCubit>().reset();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  void _analyzeImage() {
    if (_selectedImage != null) {
      context.read<DfuPredictionCubit>().predictImage(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: CustomAppBar(
                title: "DFU AI Analysis",
                back: true,
                onTap: () => context.pop(),
                notification: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageSelector(),
                    SizedBox(height: 24.h),
                    BlocBuilder<DfuPredictionCubit, DfuPredictionState>(
                      builder: (context, state) {
                        if (state is DfuPredictionLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is DfuPredictionError) {
                          return Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              state.message,
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: K.sg,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else if (state is DfuPredictionSuccess) {
                          return _buildResults(state);
                        }
                        return const SizedBox();
                      },
                    ),
                    SizedBox(height: 24.h),
                    if (_selectedImage != null)
                      ElevatedButton(
                        onPressed: _analyzeImage,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: context.color.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Analyze Image",
                          style: TextStyle(
                            fontFamily: K.sg,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return GestureDetector(
      onTap: () => _showPickerOptions(),
      child: Container(
        height: 250.h,
        decoration: BoxDecoration(
          color: context.color.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.color.primaryColor?.withOpacity(0.5) ?? Colors.blue,
            width: 2,
            style: _selectedImage == null
                ? BorderStyle.solid
                : BorderStyle.none,
          ),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 48.sp,
                    color: context.color.primaryColor,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Tap to select an image",
                    style: TextStyle(
                      fontFamily: K.sg,
                      fontSize: 16.sp,
                      color: context.color.hintColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.color.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: context.color.primaryColor,
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    fontFamily: K.sg,
                    color: context.color.textColor,
                  ),
                ),
                onTap: () {
                  context.pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: context.color.primaryColor,
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    fontFamily: K.sg,
                    color: context.color.textColor,
                  ),
                ),
                onTap: () {
                  context.pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResults(DfuPredictionSuccess state) {
    final response = state.response;
    final primaryColor = context.color.primaryColor ?? Colors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Analysis Results",
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: context.color.textColor,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: response.ulcerDetected
                ? Colors.red.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: response.ulcerDetected ? Colors.red : Colors.green,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    response.ulcerDetected
                        ? Icons.warning_rounded
                        : Icons.check_circle_rounded,
                    color: response.ulcerDetected ? Colors.red : Colors.green,
                    size: 32.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      response.ulcerDetected
                          ? "Ulcer Detected"
                          : "No Ulcer Detected",
                      style: TextStyle(
                        fontFamily: K.sg,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: response.ulcerDetected
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              if (response.ulcerDetected) ...[
                SizedBox(height: 16.h),
                _buildStatRow(
                  "Coverage",
                  "${response.ulcerCoverage.toStringAsFixed(2)}%",
                ),
                SizedBox(height: 8.h),
                _buildStatRow("Ulcer Pixels", "${response.ulcerPixels}"),
              ],
              SizedBox(height: 8.h),
              _buildStatRow("Inference Time", "${response.inferenceMs} ms"),
            ],
          ),
        ),
        if (response.ulcerDetected && response.overlayB64.isNotEmpty) ...[
          SizedBox(height: 24.h),
          Text(
            "Segmentation Overlay",
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: context.color.textColor,
            ),
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(
              base64Decode(response.overlayB64),
              fit: BoxFit.cover,
            ),
          ),
        ],
        SizedBox(height: 24.h),
        ElevatedButton(
          onPressed: () => _showSaveDialog(state),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Save Result",
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _showSaveDialog(DfuPredictionSuccess state) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: context.color.cardColor,
          title: Text(
            "Save DFU Assessment",
            style: TextStyle(fontFamily: K.sg, color: context.color.textColor),
          ),
          content: TextField(
            controller: titleController,
            style: TextStyle(color: context.color.textColor),
            decoration: InputDecoration(
              hintText: "Enter a title (e.g. Left Foot)",
              hintStyle: TextStyle(color: context.color.hintColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: context.color.primaryColor ?? Colors.blue,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: TextStyle(color: context.color.hintColor),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                _saveResult(titleController.text.trim(), state);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.color.primaryColor,
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveResult(String title, DfuPredictionSuccess state) async {
    if (_selectedImage == null) return;
    try {
      final response = state.response;
      String? overlayPath;

      if (response.overlayB64.isNotEmpty) {
        final bytes = base64Decode(response.overlayB64);
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
          '${dir.path}/dfu_overlay_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await file.writeAsBytes(bytes);
        overlayPath = file.path;
      }

      if (mounted) {
        await context.read<DfuTestCubit>().addDfuTest(
          name: title,
          imagePaths: [_selectedImage!.path],
          ulcerDetected: response.ulcerDetected,
          ulcerCoverage: response.ulcerCoverage,
          ulcerPixels: response.ulcerPixels,
          overlayImagePath: overlayPath,
          inferenceMs: response.inferenceMs.toInt(),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved successfully!')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    }
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 14.sp,
            color: context.color.textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: context.color.textColor,
          ),
        ),
      ],
    );
  }
}
