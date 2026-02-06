import 'package:diamate/constant.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:diamate/core/extensions/context_extension.dart';
import 'package:diamate/core/routes/app_routes.dart';
import 'package:diamate/core/services/services_locator.dart';
import 'package:diamate/features/dfu_test/presentation/managers/dfu_test_cubit.dart';
import 'package:diamate/features/dfu_test/presentation/views/dfu_tests_list_view.dart';
import 'package:diamate/features/lab_tests/presentation/managers/lab_test_cubit.dart';
import 'package:diamate/features/lab_tests/presentation/views/lab_tests_list_view.dart';
import 'package:diamate/features/profile/presentation/widgets/permissions_bottom_sheet.dart';
import 'package:diamate/features/profile/presentation/widgets/theme_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker _picker = ImagePicker();
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final status = await Permission.notification.status;
    setState(() {
      _notificationsEnabled =
          status.isGranted || status.isLimited || status.isProvisional;
    });
  }

  Future<void> _pickImage() async {
    final status = await Permission.photos.request();
    if (status.isGranted || status.isLimited) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Mock success for now
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile image updated")),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card (Header)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.color.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.color.primaryColor!,
                              width: 3,
                            ),
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: context.color.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.color.cardColor!,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Abdelmenam Adel",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: context.color.textColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.color.primaryColor!.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "abdelmoneim.adel5@gmail.com",
                              style: TextStyle(
                                color: context.color.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// Section: Account Settings
              _ProfileSection(
                title: "Account Settings",
                children: [
                  _ProfileTile(
                    title: "Account Information",
                    icon: Icons.person_outline_rounded,
                    onTap: () {},
                  ),
                  _ProfileTile(
                    title: "Your Drugs",
                    icon: Icons.medication_outlined,
                    onTap: () {
                      // TODO: Navigate to drugs view
                    },
                  ),
                  _ProfileTile(
                    title: "Permissions",
                    icon: Icons.shield_outlined,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const PermissionsBottomSheet(),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Section: Health Records
              _ProfileSection(
                title: "Health Records",
                children: [
                  _ProfileTile(
                    title: "Glucose Readings",
                    icon: Icons.bloodtype_outlined,
                    onTap: () {
                      // TODO: Navigate to glucose view
                    },
                  ),
                  _ProfileTile(
                    title: "Lab Test Results",
                    icon: Icons.biotech_rounded,
                    onTap: () {
                      context.push(
                        BlocProvider<LabTestCubit>(
                          create: (context) => sl<LabTestCubit>(),
                          child: const LabTestsListView(),
                        ),
                      );
                    },
                  ),
                  _ProfileTile(
                    title: "DFU Test Results",
                    icon: Icons.personal_injury_outlined,
                    onTap: () {
                      context.push(
                        BlocProvider<DfuTestCubit>(
                          create: (context) => sl<DfuTestCubit>(),
                          child: const DfuTestsListView(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Section: App Settings
              _ProfileSection(
                title: "App Settings",
                children: [
                  _ProfileTile(
                    title: "Language",
                    icon: Icons.language_outlined,
                    onTap: () {},
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "English",
                          style: TextStyle(
                            color: context.color.hintColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: context.color.hintColor?.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  _ProfileTile(
                    title: "Notifications",
                    icon: Icons.notifications_outlined,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const PermissionsBottomSheet(),
                      ).then((_) => _checkNotificationStatus());
                    },
                    trailing: Switch.adaptive(
                      value: _notificationsEnabled,
                      onChanged: (val) async {
                        if (val) {
                          final status = await Permission.notification
                              .request();
                          setState(() {
                            _notificationsEnabled =
                                status.isGranted ||
                                status.isLimited ||
                                status.isProvisional;
                          });
                          if (status.isPermanentlyDenied) {
                            openAppSettings();
                          }
                        } else {
                          // Toggling off locally is just for UI here, usually you'd save it to shared_prefs
                          setState(() {
                            _notificationsEnabled = false;
                          });
                        }
                      },
                      activeColor: context.color.primaryColor,
                    ),
                  ),
                  _ProfileTile(
                    title: "Theme",
                    icon: Icons.nightlight_round_outlined,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const ThemeBottomSheet(),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Theme.of(context).brightness == Brightness.dark
                              ? "Dark"
                              : "Light",
                          style: TextStyle(
                            color: context.color.hintColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: context.color.hintColor?.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Section: Others
              _ProfileSection(
                title: "Others",
                children: [
                  _ProfileTile(
                    title: "Help Center",
                    icon: Icons.help_outline_rounded,
                    onTap: () {},
                  ),
                  _ProfileTile(
                    title: "FAQs",
                    icon: Icons.question_answer_outlined,
                    onTap: () {},
                  ),
                  _ProfileTile(
                    title: "About Developers",
                    icon: Icons.code_rounded,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: Colors.red.withOpacity(0.5),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      foregroundColor: Colors.red,
                    ),
                    onPressed: () {
                      SecureStorage.setBoolean(key: K.isLogged, value: false);
                      SecureStorage.setBoolean(
                        key: 'has_welcome_v1',
                        value: false,
                      );
                      context.pushNamedAndRemoveUntil(AppRoutes.splash);
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Version Info
              Center(
                child: Text(
                  "Version 1.0.0 (Build 102)",
                  style: TextStyle(
                    color: context.color.hintColor?.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: K.sg,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// --------------------------------------------------
/// Profile Section Widget (Grouped Card)
/// --------------------------------------------------
class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: context.color.textColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.color.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color:
                  context.color.hintColor?.withOpacity(0.1) ??
                  Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final widget = entry.value;
              final isLast = index == children.length - 1;

              return Column(
                children: [
                  widget,
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56, // Indent to align with text
                      endIndent: 16,
                      color: context.color.hintColor?.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// --------------------------------------------------
/// Profile Tile Widget (Updated Design)
/// --------------------------------------------------
class _ProfileTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ProfileTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon with background
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.color.hintColor?.withOpacity(
                  0.05,
                ), // Subtle gray
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: context.color.textColor, // Dark icon
              ),
            ),

            const SizedBox(width: 16),

            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: context.color.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Trailing Widget
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: context.color.hintColor?.withOpacity(0.5),
              ),
          ],
        ),
      ),
    );
  }
}
