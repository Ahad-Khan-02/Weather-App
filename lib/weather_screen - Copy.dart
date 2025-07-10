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
      String city = "Karachi";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Karachi, Pakistan",
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
          //OR:
          // InkWell(
          //   onTap: () {
          //     print("refresh");
          //   },
          //   child: const Icon(Icons.refresh),
          // ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
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

          return Padding(
            //wraping column into padding (to increase sperate distances b/w cards)
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //Main Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    //wraping card into sizebox/conatainer
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
                    "Weather Forcast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                /*
                      the method of making weidgets with loops in not wrong 
                      but it is not good for performance of app as all the widgets
                      (lets suppose i<30) create at the same time and will slow 
                      the the aap so instead of this we use listview.builder which 
                      creates widgets when we scroll
                      */
                //       for (int i = 0; i < 5; i++)
                //         HourlyForcastItem(
                //             icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                     "Clouds"
                //                 ? Icons.cloud
                //                 : data['list'][i + 1]['weather'][0]['main'] ==
                //                         "Rain"
                //                     ? Icons.cloudy_snowing
                //                     : Icons.sunny,
                //             time: data['list'][i + 1]['dt'].toString(),
                //             temp:
                //                 data['list'][i + 1]['main']['temp'].toString()),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final hourlysky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final time =
                            DateTime.parse(data['list'][index + 1]['dt_txt']);

                        return HourlyForcastItem(
                            icon: hourlysky == "Clouds"
                                ? Icons.cloud
                                : hourlysky == "Rain"
                                    ? Icons.cloudy_snowing
                                    : Icons.sunny,
                            time: DateFormat.j().format(time),
                            temp: (data['list'][index + 1]['main']['temp'] -
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
                        value: currentHumidity),
                    AdditionalInfoItem(
                        icon: Icons.air,
                        label: "Wind Speed",
                        value: currentWindspeed),
                    AdditionalInfoItem(
                        icon: Icons.warning,
                        label: "Pressure",
                        value: currentPressure),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
