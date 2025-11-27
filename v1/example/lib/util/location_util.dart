import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class ExampleLocationUtil {
  static const locationPermission = Permission.locationWhenInUse;

  static Future<bool> get _hasPermission async {
    final denied = await locationPermission.isDenied;
    return !denied;
  }

  static Future<bool> _requestPermission() async {
    final status = await locationPermission.request();
    return status.isGranted;
  }

  static Future<bool> requestAndGrantedCheck() async {
    if (Platform.isAndroid) {
      final enabled = await _hasPermission; // 권한이 있는지 확인합니다.
      if (enabled) return true; // 있다면, true를 반환합니다.
    }

    final granted = await _requestPermission(); // 권한이 없으므로, 권한 요청을 합니다.
    if (granted) return true; // 권한이 허용되었다면, true를 반환합니다.

    return false; // 거부되었음을 알리기 위해, false를 반환합니다.
  }
}
