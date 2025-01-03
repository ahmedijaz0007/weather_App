import '../models/weather.dart';

abstract class WeatherEvent {}

class FetchWeatherEvent extends WeatherEvent {
  final List<String> cities;
  FetchWeatherEvent({required this.cities});
}

class WeatherRefreshEvent extends WeatherEvent {
  final List<String> cities;
  WeatherRefreshEvent({required this.cities});
}

class DeleteWeatherEvent extends WeatherEvent {
  final String cityName;
  DeleteWeatherEvent({required this.cityName});
}

class ReorderWeatherEvent extends WeatherEvent {
  final List<Weather> weatherList;
  ReorderWeatherEvent({required this.weatherList});
}
