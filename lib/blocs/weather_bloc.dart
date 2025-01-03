import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../repositories/weather_repository.dart';
import '../models/weather.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) : super(WeatherInitial());

  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeatherEvent) {
      yield WeatherLoading();
      try {
        List<Weather> storedWeatherList = await _weatherRepository.loadWeatherListFromHive();
        if (storedWeatherList.isNotEmpty) {
          yield WeatherLoaded(weatherList: storedWeatherList);
        } else {
          List<Weather> weatherList = [];
          weatherList.add(await _weatherRepository.fetchWeather(event.cityName));
          await _weatherRepository.saveWeatherListToHive(weatherList);
          yield WeatherLoaded(weatherList: weatherList);
        }
      } catch (e) {
        yield WeatherError(message: e.toString());
      }
    } else if (event is WeatherRefreshEvent) {
      yield WeatherLoading();
      try {
        List<Weather> weatherList = await _weatherRepository.fetchWeatherData();
        await _weatherRepository.saveWeatherListToHive(weatherList);
        yield WeatherLoaded(weatherList: weatherList);
      } catch (e) {
        yield WeatherError(message: e.toString());
      }
    } else if (event is DeleteWeatherEvent) {
      yield WeatherLoading();
      try {
        await _weatherRepository.removeWeatherFromHive(event.cityName);
        List<Weather> updatedWeatherList = await _weatherRepository.loadWeatherListFromHive();
        yield WeatherLoaded(weatherList: updatedWeatherList);
      } catch (e) {
        yield WeatherError(message: e.toString());
      }
    } else if (event is ReorderWeatherEvent) {
      yield WeatherLoading();
      try {
        List<Weather> updatedWeatherList = event.weatherList;
        await _weatherRepository.saveWeatherListToHive(updatedWeatherList);
        yield WeatherLoaded(weatherList: updatedWeatherList);
      } catch (e) {
        yield WeatherError(message: e.toString());
      }
    }
  }
}
