import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [CustomAppBar(back: false, title: "Profile")]),
      ),
    );
  }
}
