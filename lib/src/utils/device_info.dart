import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfo {
  static AndroidDeviceInfo androidDeviceInfo;
  static IosDeviceInfo iosDeviceInfo;

  static void init() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    } else {
      iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    }
  }
}
