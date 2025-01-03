import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/weather_bloc.dart';
import '../blocs/weather_event.dart';
import '../blocs/weather_state.dart';
import '../components/weather_list.dart';
import '../repositories/weather_repository.dart';

class WeatherScreen extends StatelessWidget {
  final  cities = ['london','lahore','islamabad','mumbai','beijing'];

   WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: BlocProvider(
        create: (context) {
          final weatherRepository = WeatherRepository();
          final weatherBloc = WeatherBloc(weatherRepository);
          weatherBloc.add(FetchWeatherEvent(cities: cities));
          return weatherBloc;
        },
        child:  WeatherView(cities:cities),
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  final List<String>cities;
  const WeatherView({super.key, required this.cities});

  @override
  Widget build(BuildContext context) {
    print("cities= $cities");
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          return RefreshIndicator(
            onRefresh: () async{
              var newCities = cities;
              cities.removeWhere((val)=> val!="");
              context.read<WeatherBloc>().add(WeatherRefreshEvent(cities: newCities));

            },
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                final weatherList = state.weatherList;
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final movedCity = cities.removeAt(oldIndex);
                cities.insert(newIndex, movedCity);
                final movedItem = weatherList.removeAt(oldIndex);
                weatherList.insert(newIndex, movedItem);
                context.read<WeatherBloc>().add(ReorderWeatherEvent(weatherList: weatherList));
              },
              children: [
                for (var weather in state.weatherList)
                  Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      cities.remove(weather.cityName);
                      context.read<WeatherBloc>().add(DeleteWeatherEvent(cityName: weather.cityName ?? ""));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${weather.cityName} removed')));
                    },
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: WeatherCard(weather: weather,)
                  ),
              ],
            ),
          );
        } else if (state is WeatherError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return Container();
      },
    );
  }
}



