import 'dart:convert';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_weather/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String title = 'Dot Weather';
  Map location = {};

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
          brightness: Brightness.light, barBackgroundColor: Colors.transparent),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 0, bottom: 0, left: 0, right: 0, child: timeOfDay()),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: FutureBuilder(
                  future: getLocation(),
                  builder: (context, AsyncSnapshot<Map> location) {
                    if (location.hasData) {
                      return FutureBuilder(
                          future: getWeather(
                              latitude: location.data!['latitude'],
                              longitude: location.data!['longitude']),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var weather =
                                  jsonDecode(snapshot.data.toString());
                              String city = weather['location']['name'];
                              Map currentData = weather['current'];
                              Map forecastday =
                                  weather['forecast']['forecastday'][0];
                              Map currentDay = forecastday['day'];
                              print(currentDay);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    city,
                                    style: GoogleFonts.lato(
                                        fontSize: 48, color: Colors.white),
                                  ),
                                  /* CachedNetworkImage(
                                    imageUrl: 'https:' +
                                        currentData['condition']['icon'],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.contain,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),*/
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentData['temp_c'].toString(),
                                        style: GoogleFonts.lato(
                                            fontSize: 110, color: Colors.white),
                                      ),
                                      Text(
                                        '°',
                                        style: GoogleFonts.lato(
                                            fontSize: 110, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    currentData['condition']['text'].toString(),
                                    style: GoogleFonts.lato(
                                        fontSize: 65, color: Colors.white),
                                  ),
                                ],
                              );
                            } else {
                              return const CupertinoActivityIndicator();
                            }
                          });
                    } else {
                      return const CupertinoActivityIndicator();
                    }
                  }),
            ),
            const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [])),
          ],
        ),
      ),
    );
  }

  Widget timeOfDay() {
    int hour = TimeOfDay.now().hour;
    if (hour >= 18 && hour < 20) {
      return Image.asset(
        'assets/sunset1.jpg',
        fit: BoxFit.cover,
        // opacity: const AlwaysStoppedAnimation(.5),
      );
    }
    if (hour >= 5 && hour < 7) {
      return Image.asset(
        'assets/moring1.jpg',
        fit: BoxFit.cover,
        // opacity: const AlwaysStoppedAnimation(.5),
      );
    }
    if (hour >= 20 && hour <= 24 || hour >= 1 && hour < 5) {
      return Image.asset(
        'assets/night1.jpg',
        fit: BoxFit.cover,
        // opacity: const AlwaysStoppedAnimation(.5),
      );
    }

    return Image.asset(
      'assets/day1.jpg',
      fit: BoxFit.cover,
      // opacity: const AlwaysStoppedAnimation(.5),
    );
  }

  Center getdata() {
    return Center(
      child: SingleChildScrollView(
          child: FutureBuilder(
        future: getLocation(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            location = snapshot.data!;
            title = location['regionName'];
            return Center(
                child: FutureBuilder(
              future: getWeather(
                  latitude: location['latitude'],
                  longitude: location['longitude']),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  Map weather = jsonDecode(snapshot.data.toString());
                  return Text(weather['dataseries'][0].toString());
                } else {
                  return const CupertinoActivityIndicator();
                }
              },
            ));
          }

          return const CupertinoActivityIndicator();
        },
      )),
    );
  }
}
