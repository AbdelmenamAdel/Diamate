import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/medications/presentation/managers/medication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicationsListView extends StatefulWidget {
  const MedicationsListView({super.key});

  @override
  State<MedicationsListView> createState() => _MedicationsListViewState();
}

class _MedicationsListViewState extends State<MedicationsListView> {
  final Set<int> _selectedIndices = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    context.read<MedicationCubit>().loadMedications();
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIndices.add(index);
        _isSelectionMode = true;
      }
    });
  }

  Future<void> _deleteSelected() async {
    final cubit = context.read<MedicationCubit>();
    final sortedIndices = _selectedIndices.toList()
      ..sort((a, b) => b.compareTo(a));

    for (final index in sortedIndices) {
      await cubit.deleteMedication(index);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted ${_selectedIndices.length} medication(s)'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    setState(() {
      _selectedIndices.clear();
      _isSelectionMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: CustomAppBar(
                title: _isSelectionMode
                    ? "${_selectedIndices.length} Selected"
                    : "Your Medications",
                back: true,
                onTap: () {
                  if (_isSelectionMode) {
                    setState(() {
                      _selectedIndices.clear();
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
            Expanded(
              child: BlocBuilder<MedicationCubit, MedicationState>(
                builder: (context, state) {
                  if (state is MedicationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MedicationError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is MedicationLoaded) {
                    final medications = state.medications;

                    if (medications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              size: 64.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No medications saved yet',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        final medication = medications[index];
                        final isSelected = _selectedIndices.contains(index);

                        return GestureDetector(
                          onLongPress: () => _toggleSelection(index),
                          onTap: () {
                            if (_isSelectionMode) _toggleSelection(index);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.color.primaryColor?.withOpacity(0.1)
                                  : context.color.cardColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? context.color.primaryColor!
                                    : context.color.containerColor ??
                                          Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: context.color.primaryColor
                                        ?.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: medication.images.isNotEmpty
                                      ? Image.network(
                                          medication.images.first,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.medication,
                                                    color: context
                                                        .color
                                                        .primaryColor,
                                                  ),
                                        )
                                      : Icon(
                                          Icons.medication,
                                          color: context.color.primaryColor,
                                        ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        medication.name,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: context.color.textColor,
                                        ),
                                      ),
                                      Text(
                                        "${medication.strength} - ${medication.dosage} ${medication.type}",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: context.color.textColor
                                              ?.withOpacity(0.6),
                                        ),
                                      ),
                                      Text(
                                        "${medication.frequency} - ${medication.foodRelation}",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: context.color.textColor
                                              ?.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (medication.reminderTimes.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16.sp,
                                        color: context.color.primaryColor,
                                      ),
                                      Text(
                                        medication.reminderTimes.first,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: context.color.textColor,
                                        ),
                                      ),
                                    ],
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
