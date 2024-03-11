import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:simple_weather_flutter_app/models/weather_model.dart';

class WeatherService {
  static const baseUrl = 'http://api.weatherapi.com/v1';
  final currentUrl = baseUrl + '/current.json';
  final key = '49094324610143fe983190509242202';
  // final String apiKey;
  // WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final Uri url = Uri.parse('$currentUrl?key=$key&q=$cityName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //print(response.body);
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load weather data!');
    }
  }

  Future<String> getCurrentCity() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? cityName = placemarks[0].locality;
    return cityName??"";
  }
}
