import 'package:flutter/material.dart';
import 'package:weather_app/screens/login.screen.dart';

import 'screens/home.screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FavoriteCitiesPage(),
    );
  }
}
