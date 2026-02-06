import 'package:diamate/constant.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class LolView extends StatelessWidget {
  const LolView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔴 Circle with Apple-like icon
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.lock, size: 60, color: Colors.red),
                ),
              ),

              const SizedBox(height: 32),

              // 📝 Title
              Text(
                'App Temporarily Unavailable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: context.color.textColor,
                  fontFamily: K.sg,
                ),
              ),

              const SizedBox(height: 12),

              // 📄 Subtitle
              Text(
                'There is a problem in your phone device\nPlease try again later',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: context.color.hintColor,
                  height: 1.4,
                  fontFamily: K.sg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
