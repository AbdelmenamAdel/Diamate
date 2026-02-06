import 'package:diamate/constant.dart';
import 'package:flutter/material.dart';

class LolView extends StatelessWidget {
  const LolView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              const Text(
                'App Temporarily Unavailable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: K.sg,
                ),
              ),

              const SizedBox(height: 12),

              // 📄 Subtitle
              const Text(
                'There is a problem in your phone device\nPlease try again later',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
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
