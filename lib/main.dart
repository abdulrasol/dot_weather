import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: FutureBuilder(
          future:
              Future.delayed(const Duration(seconds: 3)).then((onValue) => 't'),
          builder: (BuildContext context, dynamic snapshot) {
            if (snapshot.hasData) {
              return Center(child: Text('snapshot'));
            }

            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}
