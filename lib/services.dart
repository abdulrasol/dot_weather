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
  
  final dio = Dio();
  return await dio.get(
      "http://www.7timer.info/bin/api.pl?lon=44.3412&lat=32.0211&product=astro&output=json");
}
