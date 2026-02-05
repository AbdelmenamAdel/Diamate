import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:diamate/core/extensions/context_extension.dart';

class PermissionsBottomSheet extends StatefulWidget {
  const PermissionsBottomSheet({super.key});

  @override
  State<PermissionsBottomSheet> createState() => _PermissionsBottomSheetState();
}

class _PermissionsBottomSheetState extends State<PermissionsBottomSheet>
    with WidgetsBindingObserver {
  // Map of permissions to manage
  final Map<Permission, PermissionStatus> _permissionStatuses = {};

  // List of permissions relevant to the app
  final List<Permission> _appPermissions = [
    Permission.notification,
    Permission.camera,
    Permission.microphone,
    Permission.photos, // Typically for iOS / Android < 13
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check permissions when user comes back from settings
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    for (var permission in _appPermissions) {
      final status = await permission.status;
      _permissionStatuses[permission] = status;
    }
    if (mounted) setState(() {});
  }

  Future<void> _handlePermissionClick(Permission permission) async {
    final status = _permissionStatuses[permission];

    if (status == PermissionStatus.granted) {
      // User likely wants to revoke? They must go to settings.
      openAppSettings();
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      // Request permission
      final result = await permission.request();
      setState(() {
        _permissionStatuses[permission] = result;
      });
    }
  }

  IconData _getIconForPermission(Permission permission) {
    if (permission == Permission.notification)
      return Icons.notifications_rounded;
    if (permission == Permission.camera) return Icons.camera_alt_rounded;
    if (permission == Permission.microphone) return Icons.mic_rounded;
    if (permission == Permission.photos) return Icons.photo_library_rounded;
    return Icons.security_rounded;
  }

  String _getNameForPermission(Permission permission) {
    if (permission == Permission.notification) return 'Notifications';
    if (permission == Permission.camera) return 'Camera';
    if (permission == Permission.microphone) return 'Microphone';
    if (permission == Permission.photos) return 'Photo Library';
    return permission.toString().split('.').last;
  }

  String _getDescriptionForPermission(Permission permission) {
    if (permission == Permission.notification)
      return 'To receive medication alerts & health insights.';
    if (permission == Permission.camera)
      return 'To scan food meals for AI analysis.';
    if (permission == Permission.microphone)
      return 'To record voice notes and chat.';
    if (permission == Permission.photos)
      return 'To upload food images from gallery.';
    return 'Required for app functionality.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4), // Light Green bg
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_moon_rounded,
                  color: const Color(0xFF16A34A), // Green
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Permissions',

                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Manage access to enhance your experience.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Permissions List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _appPermissions.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final permission = _appPermissions[index];
                final status = _permissionStatuses[permission];
                final isGranted = status == PermissionStatus.granted;

                return InkWell(
                  onTap: () => _handlePermissionClick(permission),
                  borderRadius: BorderRadius.circular(16.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isGranted ? Colors.white : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isGranted
                            ? const Color(0xFF22C55E).withOpacity(0.3)
                            : Colors.grey[300]!,
                        width: isGranted ? 1.5 : 1,
                      ),
                      boxShadow: isGranted
                          ? [
                              BoxShadow(
                                color: const Color(0xFF22C55E).withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: isGranted
                                ? const Color(0xFFDCFCE7)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: isGranted
                                ? null
                                : Border.all(color: Colors.grey[300]!),
                          ),
                          child: Icon(
                            _getIconForPermission(permission),
                            color: isGranted
                                ? const Color(0xFF16A34A)
                                : Colors.grey[500],
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 14.w),

                        // Text Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getNameForPermission(permission),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isGranted
                                      ? Colors.black87
                                      : Colors.grey[800],
                                  fontFamily: 'SpaceGrotesk',
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                _getDescriptionForPermission(permission),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey[600],
                                  height: 1.2,
                                  fontFamily: 'SpaceGrotesk',
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // Status Indicator
                        isGranted
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 14.sp,
                                      color: const Color(0xFF16A34A),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Active',
                                      style: TextStyle(
                                        color: const Color(0xFF15803D),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp,
                                        fontFamily: 'SpaceGrotesk',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Enable',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                    fontFamily: 'SpaceGrotesk',
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 24.h),

          // Total Settings Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: openAppSettings,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                foregroundColor: Colors.black87,
              ),
              icon: Icon(Icons.settings_outlined, size: 20.sp),
              label: Text(
                'Open System Settings',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
