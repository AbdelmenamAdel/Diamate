import 'dart:io';
import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/utils/time_ago.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_test_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DfuTestsListView extends StatefulWidget {
  const DfuTestsListView({super.key});

  @override
  State<DfuTestsListView> createState() => _DfuTestsListViewState();
}

class _DfuTestsListViewState extends State<DfuTestsListView> {
  @override
  void initState() {
    super.initState();
    context.read<DfuTestCubit>().loadDfuTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: CustomAppBar(
                title: "DFU Assessments",
                back: true,
                onTap: () => Navigator.pop(context),
                notification: false,
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
                        return _buildDfuCard(context, test);
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
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            "No DFU assessments found",
            style: TextStyle(
              fontFamily: K.sg,
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDfuCard(BuildContext context, dynamic test) {
    final primaryColor = context.color.primaryColor ?? Colors.blue;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        leading: Container(
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
                  ),
                )
              : Icon(Icons.image_rounded, color: primaryColor),
        ),
        title: Text(
          test.name,
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${test.imagePaths.length} Images • ${TimeAgo.formatWithDate(test.addDate, context)}",
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16.sp,
          color: Colors.grey[400],
        ),
        onTap: () {
          // Open image viewer
          _showImageViewer(context, test.name, test.imagePaths);
        },
      ),
    );
  }

  void _showImageViewer(
    BuildContext context,
    String title,
    List<String> images,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(title, style: const TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  child: Image.file(File(images[index]), fit: BoxFit.contain),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
