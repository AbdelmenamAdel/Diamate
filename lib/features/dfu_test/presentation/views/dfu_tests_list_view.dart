import 'dart:io';
import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/utils/time_ago.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_test_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_prediction_cubit.dart';
import 'package:diamate/features/dfu_test/presentation/views/dfu_prediction_view.dart';

class DfuTestsListView extends StatefulWidget {
  const DfuTestsListView({super.key});

  @override
  State<DfuTestsListView> createState() => _DfuTestsListViewState();
}

class _DfuTestsListViewState extends State<DfuTestsListView> {
  final Set<dynamic> _selectedKeys = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    context.read<DfuTestCubit>().loadDfuTests();
  }

  void _toggleSelection(dynamic key) {
    setState(() {
      if (_selectedKeys.contains(key)) {
        _selectedKeys.remove(key);
        if (_selectedKeys.isEmpty) _isSelectionMode = false;
      } else {
        _selectedKeys.add(key);
        _isSelectionMode = true;
      }
    });
  }

  Future<void> _deleteSelected() async {
    final count = _selectedKeys.length;
    await context.read<DfuTestCubit>().deleteMultipleDfuTests(
      _selectedKeys.toList(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted $count DFU assessments successfully.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    setState(() {
      _selectedKeys.clear();
      _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                final dfuTestCubit = context.read<DfuTestCubit>();
                context.push(
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<DfuPredictionCubit>(
                        create: (context) => sl<DfuPredictionCubit>(),
                      ),
                      BlocProvider<DfuTestCubit>.value(
                        value: dfuTestCubit,
                      ),
                    ],
                    child: const DfuPredictionView(),
                  ),
                );
              },
              backgroundColor: context.color.primaryColor,
              icon: const Icon(Icons.analytics_outlined, color: Colors.white),
              label: const Text(
                "AI Analysis",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: CustomAppBar(
                      title: _isSelectionMode
                          ? "${_selectedKeys.length} Selected"
                          : "DFU Assessments",
                      back: true,
                      onTap: () {
                        if (_isSelectionMode) {
                          setState(() {
                            _selectedKeys.clear();
                            _isSelectionMode = false;
                          });
                        } else {
                          context.pop();
                        }
                      },
                      notification: false,
                      trailing: _isSelectionMode
                          ? IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: _deleteSelected,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<DfuTestCubit, DfuTestState>(
                builder: (context, state) {
                  if (state is DfuTestLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DfuTestLoaded) {
                    if (state.dfuTests.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: state.dfuTests.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final test = state.dfuTests[index];
                        final isSelected = _selectedKeys.contains(test.key);
                        return GestureDetector(
                          onLongPress: () => _toggleSelection(test.key),
                          onTap: () async {
                            if (_isSelectionMode) {
                              _toggleSelection(test.key);
                            } else {
                              if (test.imagePaths.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "No images available for this test.",
                                    ),
                                  ),
                                );
                                return;
                              }

                              bool allExist = true;
                              for (String path in test.imagePaths) {
                                if (!await File(path).exists()) {
                                  allExist = false;
                                  break;
                                }
                              }

                              if (allExist) {
                                _showImageViewer(
                                  context,
                                  test,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Some image files are missing or corrupted.",
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            }
                          },
                          child: _buildDfuCard(context, test, isSelected),
                        );
                      },
                    );
                  } else if (state is DfuTestError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 64.sp,
            color:
                context.color.hintColor?.withOpacity(0.5) ?? Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            "No DFU assessments found",
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 16.sp,
              color: context.color.hintColor ?? Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDfuCard(BuildContext context, dynamic test, bool isSelected) {
    final primaryColor = context.color.primaryColor ?? Colors.blue;
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withOpacity(0.1)
            : context.color.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: primaryColor, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: _isSelectionMode
            ? Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: primaryColor,
              )
            : Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: test.imagePaths.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(test.imagePaths.first),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    color: primaryColor,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.image_rounded,
                            color: primaryColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
              ),
        title: Text(
          test.name,
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: context.color.textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${test.imagePaths.length} Images • ${TimeAgo.formatWithDate(test.addDate, context)}",
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 12.sp,
                color: context.color.hintColor ?? Colors.grey[600],
              ),
            ),
            if (test.ulcerDetected != null) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    test.ulcerDetected ? Icons.warning_rounded : Icons.check_circle_rounded,
                    color: test.ulcerDetected ? Colors.red : Colors.green,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    test.ulcerDetected ? "Ulcer Detected" : "No Ulcer Detected",
                    style: TextStyle(
                      fontFamily: K.sg,
                      fontSize: 12.sp,
                      color: test.ulcerDetected ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: _isSelectionMode
            ? null
            : Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color:
                    context.color.hintColor?.withOpacity(0.5) ??
                    Colors.grey[400],
              ),
      ),
    );
  }

  void _showImageViewer(
    BuildContext context,
    dynamic test,
  ) {
    List<String> images = List<String>.from(test.imagePaths);
    if (test.overlayImagePath != null) {
      images.add(test.overlayImagePath);
    }
    context.push(
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(test.name, style: const TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InteractiveViewer(
                            child: Image.file(File(images[index]), fit: BoxFit.contain),
                          ),
                        ),
                        if (images.length > 1)
                          Padding(
                            padding: EdgeInsets.all(8.h),
                            child: Text(
                              index == 0 ? "Original Image" : "Segmentation Overlay",
                              style: TextStyle(color: Colors.white, fontFamily: K.sg, fontSize: 16.sp),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (test.ulcerDetected != null)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          test.ulcerDetected ? Icons.warning_rounded : Icons.check_circle_rounded,
                          color: test.ulcerDetected ? Colors.red : Colors.green,
                          size: 28.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            test.ulcerDetected ? "Ulcer Detected" : "No Ulcer Detected",
                            style: TextStyle(
                              fontFamily: K.sg,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: test.ulcerDetected ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (test.ulcerDetected) ...[
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Coverage", style: TextStyle(color: Colors.white70, fontFamily: K.sg, fontSize: 14.sp)),
                          Text("${test.ulcerCoverage?.toStringAsFixed(2)}%", style: TextStyle(color: Colors.white, fontFamily: K.sg, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ulcer Pixels", style: TextStyle(color: Colors.white70, fontFamily: K.sg, fontSize: 14.sp)),
                          Text("${test.ulcerPixels}", style: TextStyle(color: Colors.white, fontFamily: K.sg, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
