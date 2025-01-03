import 'package:bloc/bloc.dart';
import 'package:weatherapp/blocs/weather_event.dart';
import 'package:weatherapp/blocs/weather_state.dart';

import '../models/weather.dart';
import '../repositories/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) : super(WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
    on<WeatherRefreshEvent>(_onRefreshWeather);
    on<DeleteWeatherEvent>(_onDeleteWeather);
    on<ReorderWeatherEvent>(_onReorderWeather);
  }



  Future<void> _onFetchWeather(FetchWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      print("fetch weather data from hive");
      List<Weather> storedWeatherList = await _weatherRepository.loadWeatherListFromHive();
      if (storedWeatherList.isNotEmpty) {
        emit(WeatherLoaded(weatherList: storedWeatherList));
      } else {
        print("fetch weather data from api");
        List<Weather> weatherList = await _weatherRepository.fetchWeatherData(event.cities);
        await _weatherRepository.saveWeatherListToHive(weatherList);
        emit(WeatherLoaded(weatherList: weatherList));
      }
    } catch (e) {
      print("error in fetch weather data");
      throw Exception(e);
      emit(WeatherError(message: e.toString()));
    }
  }

  Future<void> _onRefreshWeather(WeatherRefreshEvent event, Emitter<WeatherState> emit) async {
    print("refresh weather data");
    emit(WeatherLoading());
    try {
      List<Weather> weatherList = await _weatherRepository.fetchWeatherData(event.cities);
      await _weatherRepository.saveWeatherListToHive(weatherList);
      print("number of weathers to show ${weatherList.length}");
      emit(WeatherLoaded(weatherList: weatherList));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }

  Future<void> _onDeleteWeather(DeleteWeatherEvent event, Emitter<WeatherState> emit) async {
    print("delete weather data");
    emit(WeatherLoading());
    try {
      await _weatherRepository.removeWeatherFromHive(event.cityName);
      List<Weather> updatedWeatherList = await _weatherRepository.loadWeatherListFromHive();
      emit(WeatherLoaded(weatherList: updatedWeatherList));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }

  Future<void> _onReorderWeather(ReorderWeatherEvent event, Emitter<WeatherState> emit) async {
    print("reoder weather data");
    emit(WeatherLoading());
    try {

      await _weatherRepository.saveWeatherListToHive(event.weatherList);
      emit(WeatherLoaded(weatherList: event.weatherList));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
}
