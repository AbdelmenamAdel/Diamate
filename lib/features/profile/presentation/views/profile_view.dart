import 'dart:convert';
import 'dart:io';

import 'package:diamate/constant.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/generated/app_assets.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:diamate/core/widgets/custom_image_picker.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/lab_tests/presentation/managers/lab_test_cubit.dart';
import 'package:diamate/features/lab_tests/presentation/views/lab_tests_list_view.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_test_cubit.dart';
import 'package:diamate/features/dfu_test/presentation/views/dfu_tests_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;
  String? _base64Image;

  void _pickImage(ImageSource source) async {
    final pickedFile = await pickImageWithFile(source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = pickedFile;
        _base64Image = base64Encode(bytes);
      });
      if (mounted) Navigator.pop(context);
    }
  }

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
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!) as ImageProvider
                            : AssetImage(Assets.men3em),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            ImagePickerComponent.show(
                              context,
                              cameraOnTap: () {
                                _pickImage(ImageSource.camera);
                              },
                              galleryOnTap: () {
                                _pickImage(ImageSource.gallery);
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Icon(Icons.edit_outlined, size: 20),
                          ),
                        ),
                      ),
                    ],
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

            const SizedBox(height: 12),

            /// DFU Test Button
            _ProfileTile(
              title: "نتائج فحص القدم (DFU)",
              icon: Icons.personal_injury_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<DfuTestCubit>(
                      create: (context) => sl<DfuTestCubit>(),
                      child: const DfuTestsListView(),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            /// Lab Tests Button
            _ProfileTile(
              title: "نتائج التحاليل",
              icon: Icons.biotech_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<LabTestCubit>(
                      create: (context) => sl<LabTestCubit>(),
                      child: const LabTestsListView(),
                    ),
                  ),
                );
              },
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
                onPressed: () {
                  SecureStorage.setBoolean(key: K.isLogged, value: false);
                  context.pushNamedAndRemoveUntil(AppRoutes.splash);
                },
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
