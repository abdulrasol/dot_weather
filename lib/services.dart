import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:current_location/current_location.dart';
import 'package:dio/dio.dart';
import 'package:location/location.dart';

// Future<Map<String, dynamic>> getLocation() async {
//   if (Platform.isAndroid || Platform.isIOS) {
//     Location location = Location();
//     await location.requestService();
//     await location.requestPermission();
//   }

//   var data = await UserLocation.getValue();
//   return {
//     'regionName': data!.regionName,
//     'country': data.country,
//     'timezone': data.timezone,
//     'latitude': data.latitude,
//     'longitude': data.longitude,
//   };
// }

Future<Map<String, dynamic>> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // تحقق من أن خدمة الموقع مفعلة
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('خدمة الموقع معطلة.');
  }

  // طلب إذن الوصول إلى الموقع
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('تم رفض الإذن.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('تم رفض الإذن بشكل دائم.');
  }

  // الحصول على الموقع الحالي
  Position position = await Geolocator.getCurrentPosition();

  return {
    'latitude': position.latitude,
    'longitude': position.longitude,
    'regionName':
        'Region Not Available', // يمكنك إضافة API لتحديد اسم المنطقة بناءً على الإحداثيات
    'country': 'Country Not Available',
    'timezone': 'Timezone Not Available',
  };
}

Future getWeather({required latitude, required longitude}) async {
  const String scrent = 'f5b1de87731f4d70b2e124743242808';

  final dio = Dio();

  Response data = await dio.get(
      "http://api.weatherapi.com/v1/forecast.json?key=$scrent&q=$latitude,$longitude&days=1&aqi=no&alerts=no");

  return data;
}
