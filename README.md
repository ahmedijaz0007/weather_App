Weather App with BLoC and Hive Persistence
This weather app fetches real-time weather data for a list of cities, stores it locally using Hive, and displays it in a user-friendly interface. It uses the BLoC pattern for state management and Hive for local data persistence. The app also supports reordering cities and pull-to-refresh functionality.

Features
Fetch weather data for a list of cities.
Persist weather data using Hive.
Reorder cities and update weather data accordingly.
Pull-to-refresh functionality for updating weather data.
Tech Stack
Flutter: Framework for building the app.
BLoC (Business Logic Component): For managing app state.
Hive: Local database for storing weather data.
HTTP: For making API calls to fetch weather data.
OpenWeatherMap API: For fetching real-time weather data.
Installation
Clone the repository:

bash
Copy code
git clone https://github.com/yourusername/weather-app.git
cd weather-app
Install dependencies:

Make sure you have Flutter installed. If not, follow the instructions on the Flutter website.

Then, run the following command to get the dependencies:

bash
Copy code
flutter pub get
Set up your OpenWeatherMap API key:

Sign up on OpenWeatherMap to get an API key.
Replace 'YOUR_API_KEY' in the WeatherRepository class with your actual API key.
Example:

dart
Copy code
final String apiKey = 'YOUR_API_KEY';
Run the app:

You can now run the app on an emulator or a physical device:

bash
Copy code
flutter run
Project Structure
bash
Copy code
lib/
├── blocs/
│   ├── weather_bloc.dart           # Contains WeatherBloc logic
│   ├── weather_event.dart          # Defines events for weather
│   └── weather_state.dart          # Defines states for weather
├── models/Here's a README file template that you can use for your weather app with the BLoC pattern and Hive persistence:

---

# Weather App with BLoC and Hive Persistence

This weather app fetches real-time weather data for a list of cities, stores it locally using Hive, and displays it in a user-friendly interface. It uses the **BLoC pattern** for state management and **Hive** for local data persistence. The app also supports **reordering cities** and **pull-to-refresh** functionality.

## Features

- Fetch weather data for a list of cities.
- Persist weather data using **Hive**.
- **Reorder cities** and update weather data accordingly.
- **Pull-to-refresh** functionality for updating weather data.
- **Real-time weather updates** based on user-selected cities.

## Tech Stack

- **Flutter**: Framework for building the app.
- **BLoC (Business Logic Component)**: For managing app state.
- **Hive**: Local database for storing weather data.
- **HTTP**: For making API calls to fetch weather data.
- **OpenWeatherMap API**: For fetching real-time weather data.

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/weather-app.git
   cd weather-app
   ```

2. **Install dependencies**:

   Make sure you have Flutter installed. If not, follow the instructions on the [Flutter website](https://flutter.dev/docs/get-started/install).

   Then, run the following command to get the dependencies:

   ```bash
   flutter pub get
   ```

3. **Set up your OpenWeatherMap API key**:

   - Sign up on [OpenWeatherMap](https://openweathermap.org/) to get an API key.
   - Replace `'YOUR_API_KEY'` in the `WeatherRepository` class with your actual API key.

   Example:

   ```dart
   final String apiKey = 'YOUR_API_KEY';
   ```

4. **Run the app**:

   You can now run the app on an emulator or a physical device:

   ```bash
   flutter run
   ```


## How It Works

### WeatherBloc

The `WeatherBloc` handles the business logic of the app. It listens to the following events:

1. **FetchWeatherEvent**: Fetches weather data for the list of cities and stores it in Hive. If data already exists in Hive, it loads the stored weather data.
2. **WeatherRefreshEvent**: Triggers a refresh of the weather data.
3. **DeleteWeatherEvent**: Deletes weather data for a specific city.
4. **ReorderWeatherEvent**: Reorders the cities list and updates the weather data accordingly.

### WeatherRepository

The `WeatherRepository` is responsible for fetching weather data from the OpenWeatherMap API, saving it to Hive, and loading it from Hive. It also supports removing weather data for a specific city.

### Hive Persistence

The weather data for each city is stored locally using Hive. The data is saved in a box named `weatherBox`, and it persists even after the app is closed. The app automatically loads the data from Hive on startup.

### Reordering Cities

The user can reorder the cities in the list. Once the order is changed, the app fetches the updated weather data for the cities in the new order and updates the UI.

### Pull-to-Refresh

The app supports pull-to-refresh functionality to update the weather data for all cities in the list. When the user pulls down on the list, it triggers a refresh of the weather data.

## Usage


### Reorder Cities

1. Long-press on a city in the list.
2. Drag and drop the city to reorder the list.
3. The weather data will be updated to reflect the new city order.

### Remove a City

1. Swipe a city to the left or right to remove it from the list.
2. The weather data for that city will be removed from both the UI and Hive.

### Pull-to-Refresh

1. Pull down on the weather list to trigger a refresh.
2. The weather data for all cities will be updated.

## State Management (BLoC)

This app uses the BLoC pattern for managing the state of the weather data. The `WeatherBloc` listens for different events and emits corresponding states:

- **WeatherLoading**: Indicates that data is being loaded.
- **WeatherLoaded**: Indicates that weather data has been successfully loaded.
- **WeatherError**: Indicates that there was an error while fetching weather data.

## Future Improvements

- Add more customization options for weather display (e.g., temperature units, themes).
- Implement location-based weather fetching (e.g., using the user's GPS).
- Add more cities or regions to the weather list.



Let me know if you want any more details added or if you'd like further improvements!
│   └── weather.dart                # Weather model class
├── repositories/
│   └── weather_repository.dart     # Fetches and saves weather data
├── screens/
│   └── weather_screen.dart         # Main screen displaying weather data
├── main.dart                       # Entry point of the app
└── widgets/
├── weather_tile.dart           # Custom widget for displaying weather data
└── weather_list.dart           # Reusable list of weather data
