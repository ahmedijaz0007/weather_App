import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/weather.dart';

class WeatherRepository {
  final String apiKey = '39ef401fe38da63712ea322b3c7ba6be';
final  cities = ['london','lahore','islamabad','mumbai','beijing'];
final List<Weather> weatherList = [];

  fetchWeatherData() async {
     for(var city in cities){
       try {
         weatherList.add(await fetchWeather(city));
       }
       catch(e){
         throw Exception('Failed to load weather');
       }

  }

  }

  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<void> saveWeatherListToHive(List<Weather> weatherList) async {
    final box = await Hive.openBox('weatherBox');
    box.put('weatherList', weatherList);
  }

  Future<List<Weather>> loadWeatherListFromHive() async {
    final box = await Hive.openBox('weatherBox');
    return box.get('weatherList', defaultValue: []);
  }

  Future<void> removeWeatherFromHive(String cityName) async {
    final box = await Hive.openBox('weatherBox');
    final weatherList = box.get('weatherList', defaultValue: []);
    weatherList.removeWhere((weather) => weather.cityName == cityName);
    await box.put('weatherList', weatherList);
  }
}
