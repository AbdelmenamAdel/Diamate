import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomAppBar(
                title: '',
                onTap: () {
                  context.pushReplacementNamed(AppRoutes.main);
                },
                notification: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
