import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/weather_bloc.dart';
import '../blocs/weather_event.dart';
import '../blocs/weather_state.dart';
import '../models/weather.dart';

class WeatherListWidget extends StatefulWidget {
  @override
  WeatherListWidgetState createState() => WeatherListWidgetState();
}

class WeatherListWidgetState extends State<WeatherListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          final weatherList = state.weatherList;

          return ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final updatedList = List<Weather>.from(weatherList);
              final item = updatedList.removeAt(oldIndex);
              updatedList.insert(newIndex, item);
              context.read<WeatherBloc>().add(ReorderWeatherEvent(weatherList: updatedList));
            },
            itemCount: weatherList.length,
            itemBuilder: (context, index) {
              final weather = weatherList[index];

              return Dismissible(
                key: ValueKey(weather.cityName),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  setState(() {
                    context.read<WeatherBloc>().add(DeleteWeatherEvent(cityName: weather.cityName));
                  });
                },
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: WeatherCard(weather: weather),
              );
            },
          );
        } else if (state is WeatherError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No weather data available.'));
        }
      },
    );
  }
}

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: _getGradient(weather.temperature),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weather.cityName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                _getWeatherIcon(weather.description),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Condition: ${weather.description}',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            // Text(
            //   'Wind: ${weather.windSpeed} m/s | Humidity: ${weather.humidity}%',
            //   style: const TextStyle(fontSize: 14, color: Colors.white70),
            // ),
          ],
        ),
      ),
    );
  }

  // Dynamic gradient based on temperature
  LinearGradient _getGradient(double temperature) {
    if (temperature < 10) {
      return const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]);
    } else if (temperature < 25) {
      return const LinearGradient(colors: [Colors.orangeAccent, Colors.yellow]);
    } else {
      return const LinearGradient(colors: [Colors.redAccent, Colors.orange]);
    }
  }

  // Weather icon based on condition
  Widget _getWeatherIcon(String description) {
    if (description.contains('rain')) {
      return const Icon(Icons.beach_access, color: Colors.white, size: 40);
    } else if (description.contains('cloud')) {
      return const Icon(Icons.cloud, color: Colors.white, size: 40);
    } else if (description.contains('clear')) {
      return const Icon(Icons.wb_sunny, color: Colors.yellow, size: 40);
    } else {
      return const Icon(Icons.wb_cloudy, color: Colors.white, size: 40);
    }
  }
}
