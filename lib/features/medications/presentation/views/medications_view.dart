import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/medication_info_card.dart';
import '../widgets/medication_type_selector.dart';
import '../widgets/dosage_selector.dart';
import '../widgets/food_relation_selector.dart';
import '../widgets/reminder_time_selector.dart';

class MedicationsView extends StatefulWidget {
  const MedicationsView({super.key});

  @override
  State<MedicationsView> createState() => _MedicationsViewState();
}

class _MedicationsViewState extends State<MedicationsView> {
  final TextEditingController _drugNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();

  String _selectedType = 'Tablet';
  String _foodRelation = 'Before Food';
  String _frequency = 'Daily';
  int _dosageAmount = 1;
  List<TimeOfDay> _reminderTimes = [const TimeOfDay(hour: 12, minute: 0)];

  bool get _isFormValid => _drugNameController.text.isNotEmpty;

  final List<Map<String, List<String>>> _mockDrugsDb = [
    {
      "name": ["Insulin"],
      "image": [
        "https://cdn-icons-png.flaticon.com/512/883/883407.png",
        "https://cdn-icons-png.flaticon.com/512/883/883356.png",
      ],
    },
    {
      "name": ["Metformin"],
      "image": [
        "https://cdn-icons-png.flaticon.com/512/883/883356.png",
        "https://cdn-icons-png.flaticon.com/512/883/883356.png",
      ],
    },
    {
      "name": ["Aspirin"],
      "image": [
        "https://cdn-icons-png.flaticon.com/512/883/883445.png",
        "https://cdn-icons-png.flaticon.com/512/883/883445.png",
      ],
    },
    {
      "name": ["Amoxicillin"],
      "image": [
        "https://cdn-icons-png.flaticon.com/512/2864/2864230.png",
        "https://cdn-icons-png.flaticon.com/512/2864/2864230.png",
      ],
    },
    {
      "name": ["Lipitor"],
      "image": [
        "https://cdn-icons-png.flaticon.com/512/4605/4605156.png",
        "https://cdn-icons-png.flaticon.com/512/4605/4605156.png",
      ],
    },
    {
      "name": ["Glucophage"],
      "image": [
        "https://cdn-icons-png.flaticon.com/512/2864/2864230.png",
        "https://cdn-icons-png.flaticon.com/512/2864/2864230.png",
      ],
    },
  ];

  List<Map<String, List<String>>> _searchResults = [];
  Map<String, List<String>>? _selectedDrugData;

  @override
  void initState() {
    super.initState();
    _drugNameController.addListener(() => setState(() {}));
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        if (query.isEmpty) {
          _searchResults = [];
        } else {
          _searchResults = _mockDrugsDb
              .where((drug) => drug["name"]![0].toLowerCase().contains(query))
              .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _drugNameController.dispose();
    _searchController.dispose();
    _strengthController.dispose();
    super.dispose();
  }

  void _selectDrug(Map<String, List<String>> drugData) {
    setState(() {
      _selectedDrugData = drugData;
      _drugNameController.text = drugData["name"]![0];
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _performSearch() {
    if (_searchController.text.isEmpty) return;
    final query = _searchController.text.toLowerCase();
    _mockDrugsDb.any((drug) => drug["name"]![0].toLowerCase() == query)
        ? _selectDrug(
            _mockDrugsDb.firstWhere(
              (drug) => drug["name"]![0].toLowerCase() == query,
            ),
          )
        : _selectDrug({
            "name": [_searchController.text],
            "image": [""],
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  CustomAppBar(title: "Medications", notification: false),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      const MedicationInfoCard(),
                      SizedBox(height: 20.h),
                      _buildSearchField(context),
                      if (_searchResults.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 5.h),
                          decoration: BoxDecoration(
                            color: context.color.cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: context.color.containerColor!,
                            ),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Image.network(
                                  _searchResults[index]["image"]![0],
                                  width: 30.w,
                                  height: 30.h,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.medication),
                                ),
                                title: Text(
                                  _searchResults[index]["name"]![0],
                                  style: TextStyle(
                                    color: context.color.textColor,
                                  ),
                                ),
                                onTap: () => _selectDrug(_searchResults[index]),
                              );
                            },
                          ),
                        ),
                      if (_selectedDrugData != null) ...[
                        SizedBox(height: 20.h),
                        Text(
                          "Drug",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: context.color.textColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _buildDrugSelectionField(
                          context,
                          _drugNameController.text.isEmpty
                              ? "Select Drug"
                              : _drugNameController.text,
                        ),
                        SizedBox(height: 15.h),
                        _buildSelectedDrugImage(context),
                      ],
                      SizedBox(height: 20.h),
                      MedicationTypeSelector(
                        selectedType: _selectedType,
                        onChanged: (type) =>
                            setState(() => _selectedType = type),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Strength",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: context.color.textColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildStrengthField(context),
                      SizedBox(height: 20.h),
                      DosageSelector(
                        amount: _dosageAmount,
                        onChanged: (val) => setState(() => _dosageAmount = val),
                      ),
                      SizedBox(height: 20.h),
                      FoodRelationSelector(
                        selectedRelation: _foodRelation,
                        onChanged: (val) => setState(() => _foodRelation = val),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Frequency",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: context.color.textColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildFrequencyDropdown(context),
                      SizedBox(height: 20.h),
                      ReminderTimeSelector(
                        times: _reminderTimes,
                        onAdd: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 12, minute: 0),
                          );
                          if (picked != null) {
                            setState(() {
                              _reminderTimes.add(picked);
                            });
                          }
                        },
                        onRemove: (index) {
                          setState(() {
                            _reminderTimes.removeAt(index);
                          });
                        },
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        text: "Save",
                        onTap: _isFormValid
                            ? () {
                                // TODO: Implement save logic
                                Navigator.pop(context);
                              }
                            : null,
                        color: _isFormValid
                            ? context.color.primaryColor
                            : context.color.containerColor,
                        textColor: _isFormValid
                            ? Colors.white
                            : context.color.textColor?.withOpacity(0.5),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Stack(
      children: [
        CustomTextFormField(
          controller: _searchController,
          hint: "Drug Name",
          image: Assets.medicine,
          nodivider: true,
          onChanged: (val) {},
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 10.w,
          child: Center(
            child: GestureDetector(
              onTap: _performSearch,
              child: Container(
                height: 36.h,
                width: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.color.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: context.color.primaryColor!.withOpacity(0.3),
                  ),
                ),
                child: SvgPicture.asset(
                  Assets.searchIcon,
                  height: 20.h,
                  width: 20.w,
                  colorFilter: ColorFilter.mode(
                    context.color.primaryColor!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrugSelectionField(BuildContext context, String hint) {
    return Stack(
      children: [
        CustomTextFormField(
          hint: hint,
          readOnly: true,
          image: Assets.medicine,
          nodivider: true,
        ),
        if (_drugNameController.text.isNotEmpty)
          Positioned(
            top: 0,
            bottom: 0,
            right: 10.w,
            child: Center(
              child: IconButton(
                onPressed: () => setState(() {
                  _drugNameController.clear();
                  _selectedDrugData = null;
                }),
                icon: Icon(
                  Icons.close,
                  color: context.color.textColor?.withOpacity(0.5),
                  size: 20.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSelectedDrugImage(BuildContext context) {
    if (_selectedDrugData == null || _selectedDrugData!["image"]!.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedDrugData!["image"]!.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          return Container(
            width: 100.w,
            decoration: BoxDecoration(
              color: context.color.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: context.color.containerColor!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Image.network(
                  _selectedDrugData!["image"]![index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.medication,
                    color: context.color.textColor?.withOpacity(0.5),
                    size: 40.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStrengthField(BuildContext context) {
    return CustomTextFormField(
      controller: _strengthController,
      hint: "e.g., 500 mg / 100 units",
      image: Assets.medicine,
      nodivider: true,
    );
  }

  Widget _buildFrequencyDropdown(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xffE4E4E4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _frequency,
          dropdownColor: context.color.cardColor,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: context.color.textColor?.withOpacity(0.5),
          ),
          items: ["Daily", "Weekly", "Monthly"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: context.color.textColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() => _frequency = newValue);
            }
          },
        ),
      ),
    );
  }
}
