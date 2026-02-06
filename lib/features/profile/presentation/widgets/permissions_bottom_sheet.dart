import 'package:diamate/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsBottomSheet extends StatefulWidget {
  const PermissionsBottomSheet({super.key});

  @override
  State<PermissionsBottomSheet> createState() => _PermissionsBottomSheetState();
}

class _PermissionsBottomSheetState extends State<PermissionsBottomSheet>
    with WidgetsBindingObserver {
  final Map<Permission, PermissionStatus> _permissionStatuses = {};

  final List<Permission> _appPermissions = [
    Permission.notification,
    Permission.camera,
    Permission.microphone,
    Permission.photos,
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
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited ||
        status == PermissionStatus.provisional) {
      // Already granted, no need to do anything or maybe show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_getNameForPermission(permission)} is already enabled.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      final result = await permission.request();
      _permissionStatuses[permission] = result;
      if (mounted) setState(() {});
    }
  }

  bool _isPermissionGranted(PermissionStatus? status) {
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited ||
        status == PermissionStatus.provisional;
  }

  IconData _getIconForPermission(Permission permission) {
    if (permission == Permission.notification) {
      return Icons.notifications_active_rounded;
    }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        context.color.cardColor; // Using theme card color for sheet bg
    final textColor = context.color.textColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
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

          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_moon_rounded,
                  color: const Color(0xFF16A34A),
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Permissions',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Adaptive text color
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Manage access to enhance your experience.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          fontFamily: 'SpaceGrotesk',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _appPermissions.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final permission = _appPermissions[index];
                final status = _permissionStatuses[permission];
                final isGranted = _isPermissionGranted(status);

                // Card Color Logic
                final cardBg = isGranted
                    ? (isDark ? Colors.green.withOpacity(0.1) : Colors.white)
                    : (isDark ? Colors.grey.withOpacity(0.1) : Colors.grey[50]);

                final borderColor = isGranted
                    ? const Color(0xFF22C55E).withOpacity(0.3)
                    : (isDark
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.grey[300]!);

                return InkWell(
                  onTap: () => _handlePermissionClick(permission),
                  borderRadius: BorderRadius.circular(16.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: borderColor,
                        width: isGranted ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: isGranted
                                ? (isDark
                                      ? const Color(0xFFDCFCE7).withOpacity(0.2)
                                      : const Color(0xFFDCFCE7))
                                : (isDark
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.white),
                            shape: BoxShape.circle,
                            border: isGranted
                                ? null
                                : Border.all(
                                    color: isDark
                                        ? Colors.grey.withOpacity(0.2)
                                        : Colors.grey[300]!,
                                  ),
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
                                      ? textColor
                                      : Colors.grey[600],
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

                        isGranted
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFFDCFCE7).withOpacity(0.2)
                                      : const Color(0xFFDCFCE7),
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
                            : GestureDetector(
                                onTap: () => _handlePermissionClick(permission),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white : Colors.black,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    'Enable',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                      fontFamily: 'SpaceGrotesk',
                                    ),
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
                foregroundColor: textColor,
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
