import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<PermissionStatus> requestNotificationPermission() async {
    final permissionStatus = await Permission.notification.request();
    return permissionStatus;
  }
}