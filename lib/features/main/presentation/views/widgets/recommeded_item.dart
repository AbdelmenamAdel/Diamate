import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';

import 'package:flutter/material.dart';

class RecommededItem extends StatelessWidget {
  const RecommededItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: isDark
                  ? context.color.cardColor
                  : Colors.black.withOpacity(0.05),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(Assets.testFood),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  "Grilled Chicken Salad",
                  style: TextStyle(
                    fontSize: 10,
                    height: 2,
                    fontFamily: K.sg,
                    fontWeight: FontWeight.w600,
                    color: context.color.textColor,
                  ),
                ),
                Text(
                  "150 Cal",
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: K.sg,
                    fontWeight: FontWeight.w600,
                    color: context.color.textColor,
                  ),
                ),
                Text(
                  "31 protien .50 Carbs",
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: K.sg,
                    fontWeight: FontWeight.w400,
                    color: context.color.textColor?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 32,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark
                  ? context.color.primaryColor?.withOpacity(0.2)
                  : context.color.primaryColor?.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                "More",
                style: TextStyle(
                  fontFamily: K.sg,
                  fontSize: 10,
                  color: isDark ? Colors.white : context.color.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
