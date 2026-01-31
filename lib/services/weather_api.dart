import 'dart:convert';

import 'package:http/http.dart' as http;

const String kOpenWeatherApiKey = 'YOUR_API_KEY'; // Замените на ваш ключ

class WeatherResult {
  final String city;
  final double temp;
  final String description;

  WeatherResult({required this.city, required this.temp, required this.description});

  factory WeatherResult.fromJson(Map<String, dynamic> json) {
    final city = json['name'] ?? '';
    final main = json['main'] ?? {};
    final weatherList = json['weather'] as List<dynamic>?;
    final description = weatherList != null && weatherList.isNotEmpty
        ? (weatherList[0]['description'] ?? '')
        : '';
    final temp = (main['temp'] != null) ? (main['temp'] as num).toDouble() : 0.0;

    return WeatherResult(city: city, temp: temp, description: description);
  }
}

class WeatherApi {
  final String apiKey;

  WeatherApi({String? apiKey}) : apiKey = apiKey ?? kOpenWeatherApiKey;

  Future<WeatherResult> fetchWeather(String city) async {
    final url = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {
        'q': city,
        'units': 'metric',
        'appid': apiKey,
      },
    );

    final resp = await http.get(url);
    if (resp.statusCode != 200) {
      throw Exception('Ошибка при получении данных: ${resp.statusCode}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return WeatherResult.fromJson(data);
  }
}
