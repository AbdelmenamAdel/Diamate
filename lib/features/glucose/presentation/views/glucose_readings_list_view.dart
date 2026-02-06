import 'dart:io';
import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/glucose/presentation/managers/glucose_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlucoseReadingsListView extends StatefulWidget {
  const GlucoseReadingsListView({super.key});

  @override
  State<GlucoseReadingsListView> createState() =>
      _GlucoseReadingsListViewState();
}

class _GlucoseReadingsListViewState extends State<GlucoseReadingsListView> {
  final Set<dynamic> _selectedKeys = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    context.read<GlucoseCubit>().loadReadings();
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
    await context.read<GlucoseCubit>().deleteMultipleReadings(
      _selectedKeys.toList(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deleted $count glucose reading${count > 1 ? 's' : ''} successfully.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    setState(() {
      _selectedKeys.clear();
      _isSelectionMode = false;
    });
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
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
              child: Row(
                children: [
                  Expanded(
                    child: CustomAppBar(
                      title: _isSelectionMode
                          ? "${_selectedKeys.length} Selected"
                          : "Glucose Readings",
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
              child: BlocBuilder<GlucoseCubit, GlucoseState>(
                builder: (context, state) {
                  if (state is GlucoseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is GlucoseError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.sp,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is GlucoseLoaded) {
                    final readings = state.readings;

                    if (readings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bloodtype_outlined,
                              size: 64.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No glucose readings yet',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Add your first reading from\nthe Glucose Monitor',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: readings.length,
                      itemBuilder: (context, index) {
                        final reading = readings[index];
                        final key = reading.key;
                        final isSelected = _selectedKeys.contains(key);

                        return GestureDetector(
                          onLongPress: () => _toggleSelection(key),
                          onTap: () {
                            if (_isSelectionMode) {
                              _toggleSelection(key);
                            } else if (reading.imagePath != null) {
                              _showImageDialog(reading.imagePath!);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (context.color.primaryColor ?? Colors.blue)
                                        .withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? (context.color.primaryColor!)
                                    : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Leading: Image or Icon
                                if (reading.imagePath != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.file(
                                      File(reading.imagePath!),
                                      width: 60.w,
                                      height: 60.w,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Container(
                                    width: 60.w,
                                    height: 60.w,
                                    decoration: BoxDecoration(
                                      color: Color(
                                        int.parse(
                                              reading.statusColor.substring(1),
                                              radix: 16,
                                            ) +
                                            0xFF000000,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.bloodtype_rounded,
                                      color: Color(
                                        int.parse(
                                              reading.statusColor.substring(1),
                                              radix: 16,
                                            ) +
                                            0xFF000000,
                                      ),
                                      size: 32.sp,
                                    ),
                                  ),
                                SizedBox(width: 16.w),

                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${reading.value.toInt()}',
                                            style: TextStyle(
                                              fontFamily: K.sg,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            'mg/dL',
                                            style: TextStyle(
                                              fontFamily: K.sg,
                                              fontSize: 14.sp,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse(
                                                      reading.statusColor
                                                          .substring(1),
                                                      radix: 16,
                                                    ) +
                                                    0xFF000000,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              reading.status,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Color(
                                                  int.parse(
                                                        reading.statusColor
                                                            .substring(1),
                                                        radix: 16,
                                                      ) +
                                                      0xFF000000,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            Icon(
                                              reading.source == 'camera'
                                                  ? Icons.camera_alt
                                                  : Icons.edit,
                                              size: 14.sp,
                                              color: Colors.grey.shade600,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              reading.source == 'camera'
                                                  ? 'Scanned'
                                                  : 'Manual',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Icon(
                                              Icons.access_time,
                                              size: 14.sp,
                                              color: Colors.grey.shade600,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              timeAgo(reading.timestamp),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Icon(
                                              Icons.schedule,
                                              size: 14.sp,
                                              color: Colors.grey.shade600,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              reading.measurementTypeDisplay,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (reading.notes != null) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          reading.notes!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade700,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // Selection checkbox
                                if (_isSelectionMode)
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (_) => _toggleSelection(key),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
}
