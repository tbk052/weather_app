import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../utils/weather_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// Key to API
  static String apiKey = '6eca4e7b142f4b48b57200917242206';

  //Init weatherInfo values`
  int temparature = 0;
  int maxTemp = 0;
  int minTemp = 0;
  String weatherStateName = '';
  int pressure = 0;
  int precipitation = 0;
  int windSpeed = 0;
  int humidity = 0;
  int uvIndex = 0;
  int vision = 0;
  int feelLike = 0;

  int isDay = 1;
  int weatherConditionCode = 0;
  String weatherIcon = '';
  final Map<String, String> weatherIconMap = {
    '1003-1': 'cloudy-day-1',
    '1003-0': 'cloudy-night-1',
    '1063-1': 'rainy-1',
    '1153-1': 'rainy-1',
    '1150-1': 'rainy-1',
    '1063-0': 'rainy-4',
    '1153-0': 'rainy-4',
    '1150-0': 'rainy-4',
    '1240-1': 'rainy-2',
    '1183-1': 'rainy-2',
    '1240-0': 'rainy-5',
    '1183-0': 'rainy-5',
    '1000-1': 'day',
    '1000-0': 'night',
    '1030-1': 'cloudy',
    '1030-0': 'cloudy',
    '1006-1': 'cloudy',
    '1006-0': 'cloudy',
    '1087-0': 'thunder',
    '1087-1': 'thunder',
    '1273-0': 'thunder',
    '1273-1': 'thunder',
  };

  String uvCategory = '';

  var currentDate = '';

  String location = 'Hanoi';
  String country = 'Vietnam';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];
  List astroInfo = [];

  String currentWeatherStatus = '';

  // call API
  String searchWeatherAPIUrl =
      'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&days=7&q=';

  void fetchWeatherData(String searchText) async {
    try {
      var searResult =
          await http.get(Uri.parse(searchWeatherAPIUrl + searchText));

      final weatherData =
          Map<String, dynamic>.from(json.decode(searResult.body) ?? 'No data');

      var locationData = weatherData["location"];

      var currentWeather = weatherData['current'];

      setState(() {
        location = locationData['name'];

        var parsedData =
            DateTime.parse(locationData['localtime'].substring(0, 10));
        var newDate = DateFormat('EEEE, d/M/y').format(parsedData);

        currentDate = newDate;

        // Update Weather info
        currentWeatherStatus = currentWeather['condition']['text'];
        temparature = currentWeather['temp_c'].toInt();
        pressure = currentWeather['pressure_mb'].toInt();
        precipitation = currentWeather['precip_mm'].toInt();
        windSpeed = currentWeather['wind_kph'].toInt();
        humidity = currentWeather['humidity'].toInt();
        uvIndex = currentWeather['uv'].toInt();
        vision = currentWeather['vis_km'].toInt();
        feelLike = currentWeather['feelslike_c'].toInt();

        isDay = currentWeather['is_day'];
        //Get watherIcon based on condition code
        weatherConditionCode = currentWeather['condition']['code'].toInt();

        String key = '$weatherConditionCode-$isDay';
        weatherIcon = weatherIconMap[key] ?? 'weather';

        //Get uvcategory
        if (uvIndex >= 1 && uvIndex <= 2) {
          uvCategory = 'Low';
        } else if (uvIndex >= 3 && uvIndex <= 5) {
          uvCategory = 'Moderate';
        } else if (uvIndex >= 6 && uvIndex <= 7) {
          uvCategory = 'High';
        } else if (uvIndex >= 8 && uvIndex <= 10) {
          uvCategory = 'Very High';
        } else if (uvIndex > 11) {
          uvCategory = 'Extreme';
        } else {
          uvCategory = 'Unknown'; // Handle unexpected values
        }

        // Update forecast data

        dailyWeatherForecast = weatherData['forecast']['forecastday'];
        hourlyWeatherForecast = dailyWeatherForecast[0]['hour'];
        // astroInfo = dailyWeatherForecast[0]['astro'];
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter, // Start color at top
        end: Alignment.bottomCenter, // End color at bottom
        colors: [
          Color.fromARGB(255, 31, 30, 35), // Darker color
          Color.fromARGB(255, 75, 83, 125), // Lighter color
        ],
      )),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {},
                      iconSize: 36,
                      color: Colors.white),
                  const SizedBox(
                    width: 60,
                  ),
                  const Text('How was your day?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                ],
              ),
              const SizedBox(
                height: 36,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('$location,',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(country,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white))
                        ],
                      ),
                      Text(currentDate,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Colors.white))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Stack(clipBehavior: Clip.none, children: [
                  Positioned(
                    top: -20,
                    right: -40,
                    child: weatherIcon.isNotEmpty
                        ? SvgPicture.asset(
                            'assets/svg/static/$weatherIcon.svg',
                            width: 240.0,
                            height: 240.0,
                          )
                        : Container(),
                  ),
                  Positioned(
                    top: 10,
                    left: 20,
                    child: Text(temparature.toString(),
                        style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                  const Positioned(
                    top: 10,
                    left: 110,
                    child: Text('°C',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ),
                  Positioned(
                      top: 110,
                      left: 20,
                      child: Text('Feel like $feelLike°C',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white))),
                  Positioned(
                      top: 160,
                      left: 20,
                      child: SizedBox(
                        width: 210,
                        child: Text(currentWeatherStatus,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Colors.white)),
                      )),
                ]),
              ),
              const SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 65, 71, 91),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          WeatherInfo(
                            title: 'Wind',
                            weatherType: 'Wind',
                            weatherDetail: '$windSpeed km/h',
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.white54,
                                  width: 0.3,
                                ),
                                right: BorderSide(
                                  color: Colors.white54,
                                  width: 0.3,
                                ),
                              ),
                            ),
                            child: WeatherInfo(
                              title: 'Humidity',
                              weatherType: 'Humidity',
                              weatherDetail: '$humidity%',
                            ),
                          ),
                          WeatherInfo(
                            title: 'UV_index',
                            weatherType: 'UV index',
                            weatherDetail: uvCategory,
                          ),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.white54,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            WeatherInfo(
                              title: 'Vision',
                              weatherType: 'Vision',
                              weatherDetail: '$vision km',
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.white54,
                                    width: 0.3,
                                  ),
                                  right: BorderSide(
                                    color: Colors.white54,
                                    width: 0.3,
                                  ),
                                ),
                              ),
                              child: WeatherInfo(
                                title: 'Precipitation',
                                weatherType: 'Precipitation',
                                weatherDetail: '$precipitation%',
                              ),
                            ),
                            WeatherInfo(
                              title: 'Pressure',
                              weatherType: 'Pressure',
                              weatherDetail: '$pressure mb',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: hourlyWeatherForecast.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= hourlyWeatherForecast.length) {
                        return Container(); // Handle out-of-bounds gracefully
                      }
                      int currentTimeIndex() {
                        DateTime now = DateTime.now();
                        int currentHour =
                            now.hour - 2; // Adjust for 100-based index
                        return currentHour;
                      }

                      int startIndex = currentTimeIndex();

                      // Calculate adjusted index for wrapping effect
                      int adjustedIndex =
                          (index + startIndex) % hourlyWeatherForecast.length;

                      String currentTime =
                          DateFormat('HH:MM:ss').format(DateTime.now());
                      String currentHour = currentTime.substring(0, 2);

                      String? forecastTime =
                          hourlyWeatherForecast[adjustedIndex]?['time']
                              ?.substring(11, 16);
                      // Use null-safety operator for 'time' key and substring

                      if (forecastTime == null) {
                        return Container(); // Handle missing data gracefully
                      }

                      String forecastHour = hourlyWeatherForecast[adjustedIndex]
                              ['time']
                          .substring(11, 13);

                      int fcCode = hourlyWeatherForecast[adjustedIndex]
                          ['condition']['code'];
                      int fcIsDay =
                          hourlyWeatherForecast[adjustedIndex]['is_day'];

                      // Get weather status

                      String fcIcon = '';
                      String key = '$fcCode-$fcIsDay';
                      fcIcon = weatherIconMap[key] ?? 'weather';

                      String forecastTemperature =
                          hourlyWeatherForecast[adjustedIndex]['temp_c']
                              .round()
                              .toString();

                      return SizedBox(
                        width: 60.0,
                        child: Column(
                          children: [
                            Text(forecastTime,
                                style: TextStyle(
                                    color: currentHour == forecastHour
                                        ? Colors.yellow[300]
                                        : Colors.white)),
                            fcIcon.isNotEmpty
                                ? SvgPicture.asset(
                                    'assets/svg/static/$fcIcon.svg',
                                  )
                                : Container(),
                            Row(
                              children: [
                                Stack(alignment: Alignment.center, children: [
                                  Container(
                                      width: 60.0,
                                      height: 2.0,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      )),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentHour == forecastHour
                                          ? Colors.yellow[300]
                                          : Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(4.0),
                                  )
                                ]),
                              ],
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Text('$forecastTemperature°C',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentHour == forecastHour
                                      ? Colors.yellow[300]
                                      : Colors.white,
                                )),
                          ],
                        ),
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
