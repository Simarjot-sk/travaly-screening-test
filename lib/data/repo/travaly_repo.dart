import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:travaly/data/model/property_dto.dart';
import 'package:travaly/data/model/search_autocomplete_item_dto.dart';
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

  Future<List<SearchAutocompleteItemDto>?> getSearchAutoCompleteSuggestions(
    String query,
  ) async {
    try {
      final request = {
        "action": "searchAutoComplete",
        "searchAutoComplete": {
          "inputText": query,
          "searchType": ["byCity", "byState", "byCountry", "byPropertyName"],
          "limit": 10,
        },
      };
      final response = await _dio.post(
        '',
        data: jsonEncode(request),
        options: Options(
          headers: {'authtoken': authToken, 'visitortoken': visitorToken},
        ),
      );

      if (response.data['status'] != true) {
        return null;
      }
      if (response.data['data']?['present'] != true) {
        return null;
      }
      final list = response.data['data']['autoCompleteList'];
      return [
        ..._parseList(list['byCity'], 'place'),
        ..._parseList(list['byState'], 'place'),
        ..._parseList(list['byCountry'], 'place'),
        ..._parseList(list['byPropertyName'], 'property'),
      ];
    } catch (err, stack) {
      log('error loading search suggestions', error: err, stackTrace: stack);
      return null;
    }
  }

  List<SearchAutocompleteItemDto> _parseList(dynamic data, String itemType) {
    try {
      final items = data['listOfResult'] as Iterable;
      return items
          .map(
            (e) => SearchAutocompleteItemDto(
              itemName: e['valueToDisplay'],
              itemType: itemType,
              searchType: e['searchArray']['type'],
              queries: (e['searchArray']['query'] as List)
                  .map((e) => e.toString())
                  .toList(),
            ),
          )
          .toList();
    } catch (err, stack) {
      log(
        'error while parsing autocomplete list',
        error: err,
        stackTrace: stack,
      );
      return [];
    }
  }

  Future<List<PropertyDto>?> getSearchResults(
    DateTime? startDate,
    DateTime? endDate,
    int adultCount,
    int kidCount,
    SearchAutocompleteItemDto autoCompleteItem,
    int page,
  ) async {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final request = {
        "action": "getSearchResultListOfHotels",
        "getSearchResultListOfHotels": {
          "searchCriteria": {
            if (startDate != null && endDate != null)
              "checkIn": dateFormat.format(startDate),
            if (startDate != null && endDate != null)
              "checkOut": dateFormat.format(endDate),
            "rooms": 1,
            "adults": adultCount,
            "children": kidCount,
            "searchType": autoCompleteItem.searchType,
            "searchQuery": autoCompleteItem.queries,
            "accommodation": [
              "all",
              "hotel",
              //allowed "hotel","resort","Boat House","bedAndBreakfast","guestHouse","Holidayhome","cottage","apartment","Home Stay", "hostel","Guest House","Camp_sites/tent","co_living","Villa","Motel","Capsule Hotel","Dome Hotel","all"
            ],
            "arrayOfExcludedSearchType": [
              "street", //allowed street, city, state, country
            ],
            "highPrice": "3000000",
            "lowPrice": "0",
            "limit": 5,
            "page": page,
            "preloaderList": [],
            "currency": "INR",
            "rid": 0,
          },
        },
      };

      final response = await _dio.post(
        '',
        data: jsonEncode(request),
        options: Options(
          headers: {'authtoken': authToken, 'visitortoken': visitorToken},
        ),
      );

      if (response.data['status'] != true) {
        return null;
      }

      final hotelList = response.data['data']['arrayOfHotelList'] as Iterable;
      return hotelList
          .map((e) => _parsePropertyFromSearchResult(e))
          .whereType<PropertyDto>()
          .toList();
    } catch (err, stack) {
      log('error while loading search results', error: err, stackTrace: stack);
      return null;
    }
  }

  PropertyDto? _parsePropertyFromSearchResult(dynamic data) {
    try {
      return PropertyDto(
        propertyName: data['propertyName'],
        propertyImage: data['propertyImage']['fullUrl'],
        propertyStar: data['propertyStar'],
        address: _parsePropertyAddress(data['propertyAddress']),
        rate: data['markedPrice']['displayAmount'],
      );
    } catch (err, stack) {
      log(
        'error while parsing property from search results',
        error: err,
        stackTrace: stack,
      );
      return null;
    }
  }
}
