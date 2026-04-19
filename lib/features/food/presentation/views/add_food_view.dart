import 'dart:io';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_button.dart';
import 'package:diamate/core/widgets/custom_image_picker.dart';
import 'package:diamate/core/widgets/custom_text_form_field.dart';
import 'package:diamate/features/food/data/models/meal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../managers/food_cubit.dart';
import 'package:diamate/core/widgets/custom_achievement_notification.dart';

class AddFoodView extends StatefulWidget {
  final List<String>? initialIngredients;

  const AddFoodView({super.key, this.initialIngredients});

  @override
  State<AddFoodView> createState() => _AddFoodViewState();
}

class _AddFoodViewState extends State<AddFoodView> {
  final TextEditingController _mealNameController = TextEditingController();
  final List<Map<String, dynamic>> _ingredients = [];
  XFile? _image;

  @override
  void initState() {
    super.initState();
    if (widget.initialIngredients != null) {
      for (var name in widget.initialIngredients!) {
        _addIngredient(name: name);
      }
    } else {
      _addIngredient();
    }
  }

  void _addIngredient({String? name}) {
    setState(() {
      _ingredients.add({
        'nameController': TextEditingController(text: name),
        'quantityController': TextEditingController(text: '100'),
      });
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients[index]['nameController'].dispose();
      _ingredients[index]['quantityController'].dispose();
      _ingredients.removeAt(index);
    });
  }

  Future<void> _pickMealImage() async {
    final XFile? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  bool get _isValid =>
      _mealNameController.text.isNotEmpty && _ingredients.isNotEmpty;

  @override
  void dispose() {
    _mealNameController.dispose();
    for (var i in _ingredients) {
      i['nameController'].dispose();
      i['quantityController'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: BlocListener<FoodCubit, FoodState>(
        listener: (context, state) {
          if (state is FoodSuccess) {
            showAchievementView(
              context: context,
              title: "Success",
              subTitle: "Meal added successfully",
            );
            Navigator.pop(context);
          } else if (state is FoodError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomAppBar(title: "Add Food Meal"),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text("Meal Name", style: _headerStyle),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        controller: _mealNameController,
                        hint: "Enter meal name (e.g. Lunch)",
                        image: Assets.food,
                        nodivider: true,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: 20.h),
                      Text("Meal Image (Optional)", style: _headerStyle),
                      SizedBox(height: 10.h),
                      _buildImagePicker(),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ingredients", style: _headerStyle),
                          IconButton(
                            onPressed: () => _addIngredient(),
                            icon: Icon(Icons.add_circle,
                                color: context.color.primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      _buildIngredientsList(),
                      SizedBox(height: 40.h),
                      BlocBuilder<FoodCubit, FoodState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: "Save & Calculate Nutrients",
                            isLoading: state is FoodLoading,
                            onTap: _isValid
                                ? () {
                                    final List<IngredientModel> ingredients =
                                        _ingredients.map((i) {
                                      return IngredientModel(
                                        name: i['nameController'].text,
                                        quantityGrams: double.tryParse(
                                                i['quantityController'].text) ??
                                            0,
                                      );
                                    }).toList();

                                    context.read<FoodCubit>().addMeal(
                                          name: _mealNameController.text,
                                          ingredients: ingredients,
                                          imagePath: _image?.path,
                                        );
                                  }
                                : null,
                          );
                        },
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

  TextStyle get _headerStyle => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: context.color.textColor,
      );

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickMealImage,
      child: Container(
        height: 150.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.color.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.color.containerColor!),
        ),
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      size: 40.sp, color: context.color.primaryColor),
                  SizedBox(height: 10.h),
                  Text("Add Meal Image",
                      style: TextStyle(color: context.color.textColor)),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.file(File(_image!.path), fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget _buildIngredientsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _ingredients.length,
      separatorBuilder: (context, index) => SizedBox(height: 15.h),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                controller: _ingredients[index]['nameController'],
                hint: "Ingredient Name",
                nodivider: true,
                onChanged: (_) => setState(() {}),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: CustomTextFormField(
                controller: _ingredients[index]['quantityController'],
                hint: "Grams",
                keyboardType: TextInputType.number,
                nodivider: true,
                onChanged: (_) => setState(() {}),
              ),
            ),
            IconButton(
              onPressed: () => _removeIngredient(index),
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
