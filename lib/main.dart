import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_weather/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//late final StatusNotifierItemClient client;

void main() async {
  /* client = StatusNotifierItemClient(
      id: 'test-client',
      iconName: 'computer-fail-symbolic',
      menu: DBusMenuItem(children: [
        DBusMenuItem(label: 'Hello'),
        DBusMenuItem(label: 'World', enabled: false),
        DBusMenuItem.separator(),
        DBusMenuItem(
            label: 'Quit', onClicked: () async => await client.close()),
      ]));
  await client.connect();
  */
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
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
          brightness: Brightness.light, barBackgroundColor: Colors.transparent),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white60,
              )),
          middle: Text(
            title,
            style: GoogleFonts.lato(color: Colors.white60),
          ),
          border: null,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
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
                                Map data = mapFromSnapshot(snapshot);

                                /*  var weather =
                                    jsonDecode(snapshot.data.toString());
                                String city = weather['location']['name'];
                                Map currentData = weather['current'];
                                Map forecastday =
                                    weather['forecast']['forecastday'][0];
                                Map weatherData = {
                                  'city': currentData['name'],
                                  'current_temp': currentData['temp_c'],
                                  'current_condition': currentData['condition']
                                      ['text'],
                                  'current_icon': currentData['condition']
                                      ['icon'],
                                  'max_tem': forecastday['day']['maxtemp_c'],
                                  'min_tem': forecastday['day']['mintemp_c'],
                                  'day_condition': forecastday['day']['condition']
                                      ['text'],
                                  'day_icon': forecastday['day']['condition']
                                      ['icon'],
                                  'hours': forecastday['hour'],
                                };
                                List hours = weatherData['hours'];
                                hours = hours.map((hour) {
                                  return {
                                    'time': hour['time'].toString().split(' ')[1],
                                    'temp': hour['temp_c'],
                                    'state': hour['condition']['text'],
                                    'icon': hour['condition']['icon'],
                                  };
                                }).toList();
                                */
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Location + date
                                    locationAndDate(data),
                                    // current temp
                                    currentTemp(data),
                                    // Hourly temp
                                    hourlyForecast(data),
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

  Column locationAndDate(Map<dynamic, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: BorderDirectional(
                bottom: BorderSide(color: Colors.white38, width: 3)),
          ),
          child: Text(
            data['city'] ?? 'lost',
            style: GoogleFonts.lato(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '${months[DateTime.now().month - 1]} ${DateTime.now().day}',
          style: GoogleFonts.lato(fontSize: 32, color: Colors.white),
        ),
        Text(
          data['day'],
          style: GoogleFonts.lato(fontSize: 24, color: Colors.white),
        ),
      ],
    );
  }

  Column currentTemp(Map<dynamic, dynamic> data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data['current_temp'],
              style: GoogleFonts.lato(fontSize: 110, color: Colors.white),
            ),
            Text(
              ' °',
              style: GoogleFonts.lato(fontSize: 110, color: Colors.white),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${data['min_temp']}',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                ),
                Text(
                  ' °  /  ',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data['max_temp'],
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                ),
                Text(
                  ' °',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        Text(
          data['current_condition'] ?? 'lost',
          style: GoogleFonts.lato(fontSize: 65, color: Colors.white),
        )
      ],
    );
  }

  Column hourlyForecast(Map<dynamic, dynamic> data) {
    return Column(
      children: [
        const Divider(
          color: Colors.white30,
          thickness: 3,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: data['hours'].map<Widget>((hour) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        hour['time'],
                        style:
                            GoogleFonts.lato(fontSize: 14, color: Colors.white),
                      ),
                      CachedNetworkImage(
                        imageUrl: 'https:${hour['icon']}',
                        // fit: BoxFit.contain,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            hour['temp'],
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            ' °',
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Map mapFromSnapshot(AsyncSnapshot snapshot) {
    int day = DateTime.now().weekday;

    const weekDay = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    var weather = jsonDecode(snapshot.data.toString());
    Map weatherData = {
      'day': weekDay[day],
      'date': weather['location']['localtime'].toString().split(' ')[0],
      'city': weather['location']['name'],
      'current_temp': weather['current']['temp_c'].toString(),
      'feel_like': weather['current']['feelslike_c'].toString(),
      'current_condition': weather['current']['condition']['text'],
      'current_icon': weather['current']['condition']['icon'],
      'max_temp':
          weather['forecast']['forecastday'][0]['day']['maxtemp_c'].toString(),
      'avg_temp':
          weather['forecast']['forecastday'][0]['day']['avgtemp_c'].toString(),
      'min_temp':
          weather['forecast']['forecastday'][0]['day']['mintemp_c'].toString(),
      'day_condition': weather['forecast']['forecastday'][0]['day']['condition']
          ['text'],
      'day_icon': weather['forecast']['forecastday'][0]['day']['condition']
          ['icon'],
      'hours': weather['forecast']['forecastday'][0]['hour'],
    };
    // print(weatherData['city']);
    weatherData['hours'] = weatherData['hours'].map((hour) {
      return {
        'time': hour['time'].toString().split(' ')[1],
        'temp': hour['temp_c'].toString(),
        'state': hour['condition']['text'],
        'icon': hour['condition']['icon'],
      };
    }).toList();
    return weatherData;
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
    if (hour >= 20 && hour <= 24 || hour >= 0 && hour < 5) {
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
