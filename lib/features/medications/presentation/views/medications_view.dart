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
  int _dosageAmount = 1;
  List<TimeOfDay> _reminderTimes = [const TimeOfDay(hour: 12, minute: 0)];

  bool get _isFormValid => _drugNameController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _drugNameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _drugNameController.dispose();
    _searchController.dispose();
    _strengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              CustomAppBar(title: "Medications", notification: false),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      const MedicationInfoCard(),
                      SizedBox(height: 20.h),
                      _buildSearchField(context),
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
                      _buildDrugSelectionField(context, "Insulin"),
                      SizedBox(height: 15.h),
                      _buildSampleDrugImages(context),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: context.color.containerColor!),
      ),
      child: Stack(
        children: [
          CustomTextFormField(
            controller: _searchController,
            hint: "Drug Name",
            image: Assets.medicine,
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 10,
            child: Center(
              child: Container(
                height: 36,
                width: 36,
                alignment: Alignment.center,
                // padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.color.scaffoldBackgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.color.primaryColor!.withOpacity(0.3),
                  ),
                ),
                child: SvgPicture.asset(
                  Assets.searchIcon,
                  height: 20.h,
                  width: 20.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrugSelectionField(BuildContext context, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.color.primaryColor!.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          CustomTextFormField(
            hint: hint,
            readOnly: true,
            image: Assets.medicine,
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 10,
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.close,
                  color: context.color.textColor?.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _selectedDrugImage = 0;

  Widget _buildSampleDrugImages(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final isSelected = _selectedDrugImage == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedDrugImage = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? context.color.primaryColor!
                      : context.color.containerColor!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: context.color.primaryColor!.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  "https://placeholder.com/80",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image,
                    color: context.color.textColor?.withOpacity(0.5),
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
    return Container(
      decoration: BoxDecoration(
        color: context.color.containerColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.color.containerColor!),
      ),
      child: TextField(
        controller: _strengthController,
        style: TextStyle(color: context.color.textColor),
        decoration: InputDecoration(
          hintText: "e.g., 500 mg / 100 units",
          hintStyle: TextStyle(
            color: context.color.textColor?.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildFrequencyDropdown(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: context.color.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.color.containerColor!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: "Daily",
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
                style: TextStyle(color: context.color.textColor),
              ),
            );
          }).toList(),
          onChanged: (newValue) {},
        ),
      ),
    );
  }
}
