import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Check and request multiple permissions
  Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
      Permission.notification,
      Permission.storage,
    ].request();

    return statuses;
  }

  /// Request Storage Permission
  Future<bool> requestStoragePermission() async {
    // Try primary storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) return true;

    // On Android 13+, Permission.storage might be denied but Permission.photos might work
    var photosStatus = await Permission.photos.request();
    if (photosStatus.isGranted || photosStatus.isLimited) return true;

    // Also check for media permissions on Android 13+
    // But since target is mostly photos/docs, this should be enough.
    return false;
  }

  /// Request Camera Permission
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request Microphone Permission
  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Request Photo Library Permission
  Future<bool> requestPhotosPermission() async {
    // Try photos first (correct for Android 13+ and iOS)
    var status = await Permission.photos.request();
    if (status.isGranted || status.isLimited) return true;

    // Fallback to storage for older Android versions
    var storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  /// Request Notification Permission
  Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.request();

    // On some Android versions, it might be already granted but .request() returns denied
    // if not handled correctly. We check status again.
    if (status.isGranted) return true;

    var currentStatus = await Permission.notification.status;
    return currentStatus.isGranted;
  }

  /// Check if a specific permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    return await permission.isGranted;
  }

  /// Handle permission when it's permanently denied
  Future<void> handlePermanentlyDenied() async {
    await openAppSettings();
  }
}
