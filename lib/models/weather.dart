import 'package:hive/hive.dart';

part 'weather.g.dart'; // Required for Hive code generation

@HiveType(typeId: 99)
class Weather {
  @HiveField(91)
  final String cityName;

  @HiveField(92)
  final double temperature;

  @HiveField(93)
  final String description;


  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,

  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'],
      description: json['weather'][0]['description'],
    );
  }
}
