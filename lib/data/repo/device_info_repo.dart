import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoRepo {
  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      return getAndroidInfo();
    } else {
      return getIosInfo();
    }
  }

  Future<Map<String, dynamic>> getAndroidInfo() async {
    final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return {
      'deviceModel': androidInfo.model,
      'deviceFingerprint': androidInfo.fingerprint,
      'deviceBrand': androidInfo.brand,
      'deviceId': androidInfo.device,
      'deviceName': androidInfo.display,
      'deviceManufacturer': androidInfo.manufacturer,
      'deviceProduct': androidInfo.product,
      'deviceSerialNumber': 'unknown',
    };
  }

  Future<Map<String, dynamic>> getIosInfo() async {
    final IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
    return {
      'deviceModel': iosInfo.model,
      'deviceFingerprint': 'N/A_iOS',
      'deviceBrand': 'Apple',
      'deviceId': iosInfo.identifierForVendor,
      'deviceName': iosInfo.name,
      'deviceManufacturer': 'Apple',
      'deviceProduct': iosInfo.model,
      'deviceSerialNumber': 'unknown',
    };
  }
}
