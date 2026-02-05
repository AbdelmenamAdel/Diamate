import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/utils/time_ago.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/lab_tests/presentation/managers/lab_test_cubit.dart';
import 'package:diamate/features/lab_tests/presentation/views/pdf_viewer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabTestsListView extends StatefulWidget {
  const LabTestsListView({super.key});

  @override
  State<LabTestsListView> createState() => _LabTestsListViewState();
}

class _LabTestsListViewState extends State<LabTestsListView> {
  bool _isDescending = true;
  bool _sortByDate = true;
  final Set<dynamic> _selectedKeys = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    context.read<LabTestCubit>().loadLabTests();
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
    await context.read<LabTestCubit>().deleteMultipleTests(
      _selectedKeys.toList(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted $count lab tests successfully.'),
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
                          : "My Lab Tests",
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
                          : IconButton(
                              icon: Icon(
                                _isDescending
                                    ? Icons.sort_rounded
                                    : Icons.filter_list_rounded,
                                color:
                                    context.color.primaryColor ?? Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isDescending = !_isDescending;
                                });
                                if (_sortByDate) {
                                  context.read<LabTestCubit>().sortTests(
                                    _isDescending,
                                  );
                                } else {
                                  context.read<LabTestCubit>().sortByName(
                                    _isDescending,
                                  );
                                }
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            if (!_isSelectionMode)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    _sortChip("Date", _sortByDate, () {
                      setState(() => _sortByDate = true);
                      context.read<LabTestCubit>().sortTests(_isDescending);
                    }),
                    SizedBox(width: 8.w),
                    _sortChip("Name", !_sortByDate, () {
                      setState(() => _sortByDate = false);
                      context.read<LabTestCubit>().sortByName(!_isDescending);
                    }),
                  ],
                ),
              ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<LabTestCubit, LabTestState>(
                builder: (context, state) {
                  if (state is LabTestLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LabTestLoaded) {
                    if (state.labTests.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: state.labTests.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final test = state.labTests[index];
                        final isSelected = _selectedKeys.contains(test.key);
                        return GestureDetector(
                          onLongPress: () => _toggleSelection(test.key),
                          onTap: () {
                            if (_isSelectionMode) {
                              _toggleSelection(test.key);
                            } else {
                              context.push(
                                PdfViewerView(
                                  title: test.name,
                                  pdfPath: test.pdfPath,
                                ),
                              );
                            }
                          },
                          child: _buildTestCard(context, test, isSelected),
                        );
                      },
                    );
                  } else if (state is LabTestError) {
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

  Widget _sortChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? (context.color.primaryColor ?? Colors.blue)
              : context.color.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? (context.color.primaryColor ?? Colors.blue)
                : context.color.hintColor?.withOpacity(0.2) ??
                      Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 12.sp,
            color: selected ? Colors.white : context.color.textColor,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
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
            Icons.description_outlined,
            size: 64.sp,
            color:
                context.color.hintColor?.withOpacity(0.5) ?? Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            "No lab tests found",
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

  Widget _buildTestCard(BuildContext context, dynamic test, bool isSelected) {
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
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: primaryColor,
                  size: 24.sp,
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
        subtitle: Text(
          TimeAgo.formatWithDate(test.addDate, context),
          style: TextStyle(
            fontFamily: K.sg,
            fontSize: 12.sp,
            color: context.color.hintColor ?? Colors.grey[600],
          ),
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
}
