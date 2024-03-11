import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_weather_flutter_app/services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(/*apiKey*/);
  Weather? _weather;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeatherByCity(String cityName) async {
    setState(() {
      _loading = true;
    });

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchWeather() async {
    String? cityName = await _weatherService.getCurrentCity();

    _fetchWeatherByCity(cityName ?? 'London');
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'animations/cloudy.json';

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return 'animations/cloudy.json';
      case 'clouds':
        return 'animations/cloudy.json';
      case 'sunny':
        return 'animations/sunny.json';
      case 'partly cloudy':
        return 'animations/partly cloudy.json';
      case 'rainy':
        return 'animations/rainy.json';
      default:
        return 'animations/rainy.json';
    }
  }

  Future<void> _showCityInputDialog() async {
    String? city = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? inputText;

        return AlertDialog(
          title: Text('Enter your city'),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, inputText);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (city != null) {
      await _fetchWeatherByCity(city);
    }else{
      print('something went wrong');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.yellow[200],
          title: Center(
              child: Text('Main weather page'),
          )
      ),
      backgroundColor: Colors.cyan,
      body: Center(
        child:
        _loading ? CircularProgressIndicator()
            : _weather != null
            ? Column(
              children: [
               Padding(
               padding: EdgeInsets.only(top: 60.0),
                child: Text(_weather?.cityName ?? 'Loading city..')
               ),
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              Text('${_weather?.temperature.round() ?? 0} C'),
              Text(_weather?.mainCondition ?? ''),
            ],
          ) :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Something went wrong'),
            ElevatedButton(
              onPressed: _showCityInputDialog,
              child: Text('Enter your city'),
            ),
          ],
        ),
      ),
    );
  }
}
