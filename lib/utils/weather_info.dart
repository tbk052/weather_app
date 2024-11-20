import 'package:flutter/material.dart';

final Map<String, IconData> weatherTypeToIcon = {
  'Pressure': Icons.thermostat_outlined,
  'Precipitation': Icons.water_drop_outlined,
  'UV_index': Icons.wb_sunny_outlined,
  'Vision': Icons.visibility,
  'Wind': Icons.air_outlined,
  'Humidity': Icons.water_damage_outlined,
  'Chance_of_rain': Icons.cloudy_snowing,
};

class WeatherInfo extends StatelessWidget {
  final String title;
  final String weatherType;
  final String weatherDetail;

  const WeatherInfo(
      {super.key,
      required this.weatherType,
      required this.weatherDetail,
      required this.title});

  @override
  Widget build(BuildContext context) {
    IconData iconData = weatherTypeToIcon[title] ?? Icons.wb_sunny;

    return Container(
      width: 125.0,
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Stack(alignment: Alignment.center, children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 75, 83, 125),
              ),
              padding: const EdgeInsets.all(14.0),
            ),
            Icon(iconData, size: 18.0, color: Colors.white)
          ]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(weatherType,
                  style: const TextStyle(fontSize: 10, color: Colors.white)),
              Text(weatherDetail,
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
