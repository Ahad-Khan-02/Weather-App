# Flutter Weather App

A beautiful and responsive weather forecast application built with **Flutter**, leveraging the **OpenWeatherMap API** to display real-time weather data. This app allows users to search for any city and view its current weather, hourly forecast, and additional information like humidity, wind speed, and atmospheric pressure.

---

## Features

- **Current Weather**
  - Displays temperature, sky conditions (clear, cloudy, rainy), and weather icons.
  - Adjusts icons based on day/night and weather conditions.

- **Hourly Forecast**
  - Shows weather for the next hours with temperature, time, and dynamic icons.

- **Additional Information**
  - Displays humidity, wind speed, and pressure in a clean card layout.

- **City Search**
  - Users can search for any city and instantly view its weather details.

- **Refresh Support**
  - Manual refresh to update data with the latest forecast.


---

## Technologies Used

- Flutter
- Dart
- HTTP package for API requests
- intl for date and time formatting
- OpenWeatherMap API for weather data

---

## Getting Started

### Prerequisites

- Flutter SDK installed
- An IDE like VS Code or Android Studio
- An OpenWeatherMap API key

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/Ahad-Khan-02/Weather-App
   cd Weather-App
flutter pub get


### Install dependencies

```bash
flutter pub get
```

### Add your OpenWeatherMap API key

Create a `secrets.dart` file in the `lib/` directory and add:

```dart
const String openWeatherAPIkey = "YOUR_API_KEY_HERE";
```

### Run the app

```bash
flutter run
```

---

## Project Structure

```
lib/
 ├── additional_info_item.dart
 ├── hourly_forecast_item.dart
 ├── weather_screen.dart
 ├── secrets.dart
 └── main.dart
```

---

## Contributing

Contributions are welcome. Please open an issue or submit a pull request to improve the app.

---

## License

This project is licensed under the MIT License.  
You are free to use and modify it for your own learning and projects.

---

## Acknowledgments

Thanks to [OpenWeatherMap](https://openweathermap.org/) for providing free weather data APIs.

Built with Flutter.

---














































