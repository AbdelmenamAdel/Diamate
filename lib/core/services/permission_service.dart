import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Check and request multiple permissions
  Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
      Permission.notification,
    ].request();

    return statuses;
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
    var status = await Permission.photos.request();
    return status.isGranted;
  }

  /// Request Notification Permission
  Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.request();
    return status.isGranted;
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
