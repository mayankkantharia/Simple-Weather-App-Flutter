import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/helpers/constants.dart';
import 'package:weather_app/widgets/weather_tiles.dart';

class MainWeatherWidget extends StatelessWidget {
  final String location;
  final String weather;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final double? windSpeed;
  final int? humidity;

  const MainWeatherWidget({
    Key? key,
    required this.location,
    required this.weather,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.windSpeed,
    required this.humidity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: myBlue,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  location.toString(),
                  style: const TextStyle(
                    color: white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${temperature.toString()}°",
                  style: const TextStyle(
                    color: white,
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "High of ${tempMax.toString()}°, Low of ${tempMin.toString()}°",
                  style: const TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                color: myBlue,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.grey[850],
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  children: <Widget>[
                    WeatherTile(
                      icon: Icons.thermostat_outlined,
                      title: 'Temperature',
                      subtitle: "${temperature.toString()}°",
                    ),
                    WeatherTile(
                      icon: Icons.filter_drama_outlined,
                      title: 'Weather',
                      subtitle: weather.toString(),
                    ),
                    WeatherTile(
                      icon: Icons.wb_sunny,
                      title: 'Humidity',
                      subtitle: "${humidity.toString()}%",
                    ),
                    WeatherTile(
                      icon: FontAwesomeIcons.wind,
                      title: 'Windspeed',
                      subtitle: "${windSpeed.toString()} MPH",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
