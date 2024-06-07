import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';

class WeatherService {
  static const String BASE_URL =
      'http://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http
          .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String? city = placemark.isNotEmpty ? placemark[0].locality : null;

      return city ?? "Unknown City";
    } catch (e) {
      throw Exception('Failed to get current city: $e');
    }
  }
}
