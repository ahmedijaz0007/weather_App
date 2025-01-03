import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/weather.dart';

class WeatherRepository {
  final String apiKey = '39ef401fe38da63712ea322b3c7ba6be';
final List<Weather> weatherList = [];

  Future<Box<List>> _openWeatherBox() async {
    if (Hive.isBoxOpen('weatherBox')) {
      return Hive.box<List>('weatherBox');
    } else {
      return await Hive.openBox<List>('weatherBox');
    }
  }

  Future<List<Weather>>fetchWeatherData(List<String> cities) async {
    try {
      for (var city in cities) {
        weatherList.add(await fetchWeather(city));
      }
      return weatherList;
    }
       catch(e){
         throw Exception('Failed to load weather');
       }

  }



  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));
        print("response of api:$response");
    if (response.statusCode == 200) {
      print(Weather.fromJson(json.decode(response.body)));

      return Weather.fromJson(json.decode(response.body));

    } else {
      throw Exception('Failed to load weather');
    }
  }


  Future<void> saveWeatherListToHive(List<Weather> weatherList) async {

    final box = await _openWeatherBox();
    await box.put('weatherList', weatherList);
  }

  Future<List<Weather>> loadWeatherListFromHive() async {

    final box = await _openWeatherBox();
    var storedData = box.get('weatherList')?.cast<Weather>();

    print('Stored data: $storedData');
    print('Type: ${storedData.runtimeType}');
    return storedData ?? [];

  }

  Future<void> removeWeatherFromHive(String cityName) async {
    final box = await _openWeatherBox();
    final weatherList = box.get('weatherList', defaultValue: []);
    weatherList?.removeWhere((weather) => weather.cityName == cityName);
    await box.put('weatherList', weatherList ??[]);
  }
}
