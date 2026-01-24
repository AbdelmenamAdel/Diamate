import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/features/main/presentation/widgets/macro_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffF5F5F5),
        border: Border.all(color: Color(0xFFE4E4E4)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: AlignmentGeometry.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: MacroChart(protein: 30, fats: 10, carbs: 60),
              ),
              Text(
                'Details',
                style: TextStyle(
                  fontFamily: K.sg,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              _detailRowWidget(text: "%60 Carbs", color: Color(0xff291564)),
              _detailRowWidget(text: "%30 Proteins", color: Color(0xff043120)),
              _detailRowWidget(text: "%10 Fats", color: Color(0xff80381E)),
            ],
          ),
          SizedBox(width: context.width * 0.10),
        ],
      ),
    );
  }

  Row _detailRowWidget({required Color color, required String text}) {
    return Row(
      children: [
        CircleAvatar(radius: 5.r, backgroundColor: color.withOpacity(.25)),
        SizedBox(width: 4.w),
        Text(
          ' $text',
          style: TextStyle(
            color: color,
            fontFamily: K.sg,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
