// ignore_for_file: avoid_print, unused_field, unused_element

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:minimal_weather_app/secrets/api_key.dart';
import 'package:minimal_weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(apiKey);
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            const Spacer(),
            const Icon(Icons.location_on, color: Colors.white),
            Text(
              _weather?.cityName ??
                  'Procurando a cidade que você está localizado..',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            const Spacer(),

            // temperature
            Text(
              '${_weather?.temperature.round().toString()}ºC',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // weather condition

            Text(
              _weather?.mainCondition ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
