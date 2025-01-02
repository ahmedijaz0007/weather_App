import 'package:hive/hive.dart';

part 'weather.g.dart';

@HiveType(typeId: 0)
class Weather {
  @HiveField(0)
  final String cityName;

  @HiveField(1)
  final double temperature;

  @HiveField(2)
  final String description;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
    );
  }
}
