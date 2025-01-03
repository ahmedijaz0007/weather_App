import '../models/weather.dart';

abstract class WeatherEvent {}

class FetchWeatherEvent extends WeatherEvent {
  final String cityName;
  FetchWeatherEvent({required this.cityName});
}

class WeatherRefreshEvent extends WeatherEvent {
  final String cityName;
  WeatherRefreshEvent({required this.cityName});
}

class DeleteWeatherEvent extends WeatherEvent {
  final String cityName;
  DeleteWeatherEvent({required this.cityName});
}

class ReorderWeatherEvent extends WeatherEvent {
  final List<Weather> weatherList;
  ReorderWeatherEvent({required this.weatherList});
}
