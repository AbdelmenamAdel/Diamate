import 'package:diamate/constant.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:flutter/material.dart';

class RecommededItem extends StatelessWidget {
  const RecommededItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // height: 140,
          // width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            color: Colors.black.withOpacity(.2),
          ),
          child: Image.asset(Assets.testFood),
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
                  fontSize: 12,
                  height: 2,
                  fontFamily: K.sg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "150 Cal",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: K.sg,

                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "31 protien .50 Carbs",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: K.sg,

                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(.3),
            // color: Color(0xFF2D9CDB4D).withOpacity(.3),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Center(
            child: Text(
              "More",
              style: TextStyle(
                fontFamily: K.sg,
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
