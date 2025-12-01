import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomAppBar(
                title: "Notifications",
                notification: false,
                onTap: () {
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
