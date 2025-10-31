import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:travaly/data/repo/device_info_repo.dart';

class TravalyRepo {
  final Dio _dio;
  final DeviceInfoRepo _deviceInfoRepo;
  final String authToken = '71523fdd8d26f585315b4233e39d9263';
  String? visitorToken;

  TravalyRepo({required Dio dio, required DeviceInfoRepo deviceInfoRepo})
    : _dio = dio,
      _deviceInfoRepo = deviceInfoRepo;

  void getAuthToken() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      androidInfo.model;
      androidInfo.brand;
      androidInfo.device;
      androidInfo.name;
      androidInfo.manufacturer;
      androidInfo.fingerprint;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      iosInfo.model;
      //apple
      iosInfo.modelName;
    }

    final request = {
      "action": "deviceRegister",
      "deviceRegister": await _deviceInfoRepo.getDeviceInfo(),
    };
    final response = await _dio.post(
      '',
      data: jsonEncode(request),
      options: Options(headers: {'authtoken': authToken}),
    );

    final status = response.data['status'];
    if (status == true) {
      visitorToken = response.data['data']['visitorToken'];
    }
  }
}
