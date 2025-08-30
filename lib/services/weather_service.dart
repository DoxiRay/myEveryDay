import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

Future<Map<String, dynamic>> fetchWeather(Position pos) async {
  final apiKey = '74f7aecb964513ea0bdb2b99f8765be9';

  final url = Uri.parse(
    'https://api.openweathermap.org/data/2.5/weather?lat=${pos.latitude}&lon=${pos.longitude}&units=metric&appid=$apiKey',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'temperature': data['main']['temp'],
      'windspeed': data['wind']['speed'],
    };
  } else {
    throw Exception('Erreur API météo');
  }
}
