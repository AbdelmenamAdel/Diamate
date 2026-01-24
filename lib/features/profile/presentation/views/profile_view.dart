import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// Custom App Bar (Optional)
            const CustomAppBar(title: "Profile", back: false),

            const SizedBox(height: 24),

            /// Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(Assets.men3em),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Abdelmoneim",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "abdelmoneim.adel5@gmail.com",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Edit Profile Button
            _ProfileTile(
              title: "تعديل الملف الشخصي",
              icon: Icons.person_outline,
              onTap: () {},
            ),

            const SizedBox(height: 12),

            /// Settings Button
            _ProfileTile(
              title: "الإعدادات",
              icon: Icons.settings_outlined,
              onTap: () {},
            ),

            const Spacer(),

            /// Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------
/// Custom UI Tile Widget (Like the mockup)
/// --------------------------------------------------
class _ProfileTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.arrow_back_ios, size: 18),
            Text(title, style: const TextStyle(fontSize: 16)),
            Icon(icon, size: 22),
          ],
        ),
      ),
    );
  }
}
