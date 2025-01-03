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
├── models/
│   └── weather.dart                # Weather model class
├── repositories/
│   └── weather_repository.dart     # Fetches and saves weather data
├── screens/
│   └── weather_screen.dart         # Main screen displaying weather data
├── main.dart                       # Entry point of the app
└── widgets/
├── weather_tile.dart           # Custom widget for displaying weather data
└── weather_list.dart           # Reusable list of weather data
