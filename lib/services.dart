import 'dart:io';

import 'package:current_location/current_location.dart';
import 'package:dio/dio.dart';
import 'package:location/location.dart';

Future<Map<String, dynamic>> getLocation() async {
  if (Platform.isAndroid || Platform.isIOS) {
    Location location = Location();
    await location.requestService();
    await location.requestPermission();
  }

  var data = await UserLocation.getValue();
  return {
    'regionName': data!.regionName,
    'country': data.country,
    'timezone': data.timezone,
    'latitude': data.latitude,
    'longitude': data.longitude,
  };
}

Future getWeather({required latitude, required longitude}) async {
  const String scrent = 'f5b1de87731f4d70b2e124743242808';

  final dio = Dio();

  Response data = await dio.get(
      "http://api.weatherapi.com/v1/forecast.json?key=$scrent&q=$latitude,$longitude&days=1&aqi=no&alerts=no");

  return data;
}
