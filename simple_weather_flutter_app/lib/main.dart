import 'package:flutter/material.dart';
import 'package:simple_weather_flutter_app/pages/bottom_nav_page.dart';
import 'package:simple_weather_flutter_app/pages/list_page.dart';
import 'package:simple_weather_flutter_app/pages/weather_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigation(),
      routes: {
        '/home': (context) => WeatherPage(),
        '/list': (context) => ListPage(),
      },
    );
  }

}
