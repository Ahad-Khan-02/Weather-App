import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String city = textEditingController.text == ""
          ? 'karachi'
          : textEditingController.text;
      
      final result = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$openWeatherAPIkey"),
      );
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw "An unexpected error";
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  TextEditingController textEditingController = TextEditingController();
  String city = 'Karachi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          textEditingController.text==''? '' :textEditingController.text.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                (snapshot.error).toString(),
              ),
            );
          }

          final data = snapshot.data!;
          final currentTemp =
              ((data['list'][0]['main']['temp']) - 273.15).toStringAsFixed(2);
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentHumidity = data['list'][0]['main']['humidity'];
          final currentWindspeed = data['list'][0]['wind']['speed'];
          final currentPressure = data['list'][0]['main']['pressure'];
          int sunriseTimestamp = data['city']['sunrise'];
          int sunsetTimestamp = data['city']['sunset'];
          DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(
              sunriseTimestamp * 1000,
              isUtc: true);
          DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(
              sunsetTimestamp * 1000,
              isUtc: true);
          Duration offset = DateTime.now().timeZoneOffset;

          DateTime correctedSunrise = sunriseTime.add(offset);
          DateTime correctedSunset = sunsetTime.add(offset);

          return textEditingController.text != ''
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: textEditingController,
                              onFieldSubmitted: (value) {
                                city = textEditingController.text;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 30,
                          ),
                          //Main Card
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "$currentTemp °C",
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          currentSky == "Clouds"
                                              ? Icons.cloud
                                              : currentSky == "Rain"
                                                  ? Icons.cloudy_snowing
                                                  : Icons.sunny,
                                          size: 38,
                                        ),
                                        Text(
                                          "$currentSky",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          //weather forcast cards
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Weather Forecast",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 8,
                                itemBuilder: (context, index) {
                                  final hourlysky = data['list'][index + 1]
                                      ['weather'][0]['main'];
                                  final time = DateTime.parse(
                                      data['list'][index + 1]['dt_txt']);
                                  int forecastTimestamp =
                                      data['list'][index + 1]['dt'];

                                  DateTime forecastTime =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          forecastTimestamp * 1000,
                                          isUtc: true);

                                  return HourlyForcastItem(
                                      icon: hourlysky == "Clouds"
                                          ? Icons.cloud
                                          : hourlysky == "Rain"
                                              ? Icons.cloudy_snowing
                                              : (forecastTime.isAfter(
                                                          correctedSunrise) &&
                                                      forecastTime.isBefore(
                                                          correctedSunset))
                                                  ? Icons.sunny
                                                  : Icons.nightlight,
                                      time: DateFormat.j().format(time),
                                      temp: (data['list'][index + 1]['main']
                                                  ['temp'] -
                                              273.15)
                                          .toStringAsFixed(2));
                                }),
                          ),

                          SizedBox(
                            height: 50,
                          ),

                          //additional info.
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Additional Information",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AdditionalInfoItem(
                                  icon: Icons.water_drop_outlined,
                                  label: "Humidity",
                                  value: "$currentHumidity%"),
                              AdditionalInfoItem(
                                  icon: Icons.air,
                                  label: "Wind Speed",
                                  value: "$currentWindspeed m/s"),
                              AdditionalInfoItem(
                                  icon: Icons.warning,
                                  label: "Pressure",
                                  value: '$currentPressure  hPa'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 18.0, left: 16, right: 16),
                    child: TextFormField(
                      controller: textEditingController,
                      onFieldSubmitted: (value) {
                        city = textEditingController.text;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
