import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChatbotBackground extends StatelessWidget {
  const ChatbotBackground({super.key, required this.child, this.trailing});
  final Widget child;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.bottomCenter,
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4EACFF), Color(0xff043978)],
            ),
          ),
        ),
        Container(
          height: double.infinity,

          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),

            color: Colors.white,
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadiusGeometry.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: Image.asset(
              Assets.background,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),

        Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomAppBar(
                  title: '',
                  onTap: () {
                    context.pushReplacementNamed(AppRoutes.main);
                  },
                  notification: false,
                  trailing: trailing,
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ],
    );
  }
}
