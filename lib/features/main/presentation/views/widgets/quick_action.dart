import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuickActionWidget extends StatelessWidget {
  const QuickActionWidget({
    super.key,
    required this.color,
    required this.text,
    this.image,
    required this.onTap,
    this.icon,
  });
  final Color color;
  final String text;
  final String? image;
  final VoidCallback onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withOpacity(.1),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(.1),
                    radius: 24,
                    child: image != null
                        ? SvgPicture.asset(image!, color: color)
                        : Icon(icon, color: color),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: K.sg,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
