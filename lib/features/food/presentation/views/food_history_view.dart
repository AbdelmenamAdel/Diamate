import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/features/food/data/models/meal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../managers/food_cubit.dart';
import '../widgets/daily_nutrition_summary.dart';
import '../widgets/meal_history_card.dart';

class FoodHistoryView extends StatefulWidget {
  const FoodHistoryView({super.key});

  @override
  State<FoodHistoryView> createState() => _FoodHistoryViewState();
}

class _FoodHistoryViewState extends State<FoodHistoryView> {
  final int _initialPage = 10000;
  late PageController _pageController;
  late ScrollController _calendarController;
  late DateTime _selectedDate;
  final double _itemWidth = 68.w;
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _pageController = PageController(initialPage: _initialPage);
    _calendarController = ScrollController();

    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodCubit>().loadMealsForDate(_selectedDate);
    });
  }

  void _onPageChanged(int index) {
    if (_isAutoScrolling) return;

    final diff = index - _initialPage;
    final newDate = DateTime.now().add(Duration(days: diff));
    setState(() {
      _selectedDate = newDate;
    });

    // Sync calendar scroll if not currently in an auto-scroll animation
    if (_calendarController.hasClients) {
      final calendarIndex = diff.abs().toDouble();
      final targetOffset = calendarIndex * _itemWidth;

      // Using animateTo for smooth tracking during manual swipe
      _calendarController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }

    context.read<FoodCubit>().loadMealsForDate(newDate);
  }

  void _onDateSelected(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);
    final diff = selected.difference(today).inDays;

    _pageController.animateToPage(
      _initialPage + diff,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToToday() {
    if (_isAutoScrolling) return;

    setState(() {
      _isAutoScrolling = true;
      _selectedDate = DateTime.now();
    });

    // First, jump/animate calendar to 0
    if (_calendarController.hasClients) {
      _calendarController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }

    // Then animate page view
    _pageController
        .animateToPage(
          _initialPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        )
        .then((_) {
          if (mounted) {
            setState(() => _isAutoScrolling = false);
            // Final sync check
            context.read<FoodCubit>().loadMealsForDate(_selectedDate);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            //   child: CustomAppBar(title: "Food History"),
            // ),

            // Month Header and Today Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(_selectedDate),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: context.color.textColor,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _goToToday,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      backgroundColor: context.color.primaryColor?.withOpacity(
                        0.1,
                      ),
                    ),
                    icon: Icon(
                      Icons.today,
                      size: 18.sp,
                      color: context.color.primaryColor,
                    ),
                    label: Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: context.color.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Horizontal Calendar
            _buildHorizontalCalendar(),

            SizedBox(height: 20.h),

            // PageView for Days
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final diff = index - _initialPage;
                  final date = DateTime.now().add(Duration(days: diff));
                  return _DailyLogContent(date: date);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        controller: _calendarController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        // Limit to last 6 months (180 days) + current day (0)
        itemCount: 181,
        itemBuilder: (context, index) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          // index 0 is today, index 1 is yesterday, etc.
          final date = today.subtract(Duration(days: index));

          final isSelected =
              date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          final isRealToday =
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;

          return GestureDetector(
            onTap: () => _onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.color.primaryColor
                    : context.color.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                border: isRealToday && !isSelected
                    ? Border.all(color: context.color.primaryColor!, width: 2)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: context.color.primaryColor!.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected
                          ? Colors.white70
                          : context.color.hintColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : context.color.textColor,
                    ),
                  ),
                  if (isRealToday)
                    Container(
                      margin: EdgeInsets.only(top: 2.h),
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : context.color.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DailyLogContent extends StatelessWidget {
  final DateTime date;

  const _DailyLogContent({required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCubit, FoodState>(
      builder: (context, state) {
        List<MealModel> meals = [];
        bool isLoading = false;

        if (state is FoodHistoryLoading) {
          isLoading = true;
        } else if (state is FoodHistoryLoaded) {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          meals = state.meals[normalizedDate] ?? [];
        }

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (meals.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.no_food_outlined,
                size: 80.sp,
                color: context.color.hintColor?.withOpacity(0.4),
              ),
              SizedBox(height: 16.h),
              Text(
                "No meals recorded",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: context.color.hintColor,
                ),
              ),
              Text(
                DateFormat('MMMM dd, yyyy').format(date),
                style: TextStyle(color: context.color.hintColor),
              ),
            ],
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            Text(
              DateFormat('EEEE, MMMM dd').format(date),
              style: TextStyle(
                fontSize: 14.sp,
                color: context.color.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            DailyNutritionSummary(meals: meals),
            SizedBox(height: 24.h),
            Text(
              "Meal Logs",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: context.color.textColor,
              ),
            ),
            SizedBox(height: 16.h),
            ...meals.map((meal) => MealHistoryCard(meal: meal)).toList(),
            SizedBox(height: 30.h),
          ],
        );
      },
    );
  }
}
