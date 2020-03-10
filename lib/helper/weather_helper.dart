import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

const OpenWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';
const WEATHER_API_KEY = 'bb361fd7320cd1d2a0e8e3f54d135819';

class WeatherHelper {
  static Future<Weather> getWeatherFromLocation(double lat, double long) async {
    final url =
        '$OpenWeatherMapURL?lat=$lat&lon=$long&appid=$WEATHER_API_KEY&units=metric';
    print(url);
    final respond = await http.get(url);
    final temperatureRaw = jsonDecode(respond.body)['main']['temp'];
    final int condition = jsonDecode(respond.body)['weather'][0]['id'];
    print(temperatureRaw);
    print(condition);
    final weatherData = Weather(
      temperature: temperatureRaw.toInt(),
      condition: condition,
    );
    print(weatherData.temperature);
    print(weatherData.condition);
    return weatherData;
  }
}
