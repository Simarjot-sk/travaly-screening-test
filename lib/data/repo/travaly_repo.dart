import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:travaly/data/model/property_dto.dart';
import 'package:travaly/data/repo/device_info_repo.dart';

class TravalyRepo {
  final Dio _dio;
  final DeviceInfoRepo _deviceInfoRepo;
  final String authToken = '71523fdd8d26f585315b4233e39d9263';
  String? visitorToken;

  TravalyRepo({required Dio dio, required DeviceInfoRepo deviceInfoRepo})
    : _dio = dio,
      _deviceInfoRepo = deviceInfoRepo;

  Future<bool> getVisitorToken() async {
    try {
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
      return true;
    } catch (err, stack) {
      log(
        'error while getting the visitor token',
        error: err,
        stackTrace: stack,
      );
      return false;
    }
  }

  Future<List<PropertyDto>?> getHotelList() async {
    try {
      final request = {
        "action": "popularStay",
        "popularStay": {
          "limit": 10,
          "entityType": "hotel",
          //hotel, resort, Home Stay, Camp_sites/tent, Any
          "filter": {
            "searchType": "byRandom", //byCity, byState, byCountry, byRandom,
          },
          "currency": "INR",
        },
      };
      final response = await _dio.post(
        '',
        data: jsonEncode(request),
        options: Options(
          headers: {'authtoken': authToken, 'visitortoken': visitorToken},
        ),
      );

      final status = response.data['status'];
      if (status == true) {
        final data = response.data['data'] as List;
        return data
            .map((e) => _parseProperty(e))
            .whereType<PropertyDto>()
            .toList();
      }
      return null;
    } catch (err, stack) {
      log('error while fetching properties', error: err, stackTrace: stack);
      return null;
    }
  }

  PropertyDto? _parseProperty(dynamic data) {
    if (data == null) return null;
    try {
      return PropertyDto(
        propertyName: data['propertyName'],
        propertyImage: data['propertyImage'],
        propertyStar: data['propertyStar'],
        rate: data['markedPrice']?['displayAmount'],
        address: _parsePropertyAddress(data['propertyAddress']),
      );
    } catch (err, stack) {
      log('error while parsing property', error: err, stackTrace: stack);
      return null;
    }
  }

  PropertyAddress? _parsePropertyAddress(dynamic data) {
    if (data == null) return null;
    try {
      return PropertyAddress(
        street: data['street'],
        city: data['city'],
        state: data['state'],
        country: data['country'],
        mapAddress: data['map_address'],
      );
    } catch (err, stack) {
      log(
        'error while parsing property address',
        error: err,
        stackTrace: stack,
      );
      return null;
    }
  }
}
