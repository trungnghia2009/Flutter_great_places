import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../helper/weather_helper.dart';

const kApiKey = 'bb361fd7320cd1d2a0e8e3f54d135819';

class WeatherPlace with ChangeNotifier {
  Weather _weather;

  Weather get weather {
    return _weather;
  }

  Future<void> fetchAndSetWeather(double lat, double long) async {
    final currentWeather =
        await WeatherHelper.getWeatherFromLocation(lat, long);
    _weather = currentWeather;
    notifyListeners();
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
