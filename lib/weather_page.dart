import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proiect/task.dart';
import 'package:proiect/task_controller.dart';
import 'package:proiect/weather_mapping.dart';

import 'task_add.dart';
import 'custom_button.dart';

class WeatherPage extends StatefulWidget {
  final String city;
  final double temperature;
  final String weatherMain;
  final String description;

  const WeatherPage({
    required this.city,
    required this.temperature,
    required this.weatherMain,
    required this.description,
  });

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isCelsius = true;

  double convertTemperature(double temperature, bool isCelsius) {
    if (isCelsius) {
      return temperature;
    } else {
      return (temperature * 9 / 5) + 32;
    }
  }

  String getTemperatureUnit(bool isCelsius) {
    return isCelsius ? '°C' : '°F';
  }

  @override
  Widget build(BuildContext context) {
    final convertedTemperature = convertTemperature(widget.temperature, isCelsius);

    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WeatherMap.mapStringToIcon(
              context,
              widget.weatherMain,
              75,
            ),
            Text(
              widget.city,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${convertedTemperature.toStringAsFixed(1)} ${getTemperatureUnit(isCelsius)}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.weatherMain,
              style: TextStyle(
                fontSize: 38,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _getWeatherDescription(widget.weatherMain),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 40),
            CustomButton(
              onTap: () {
                String taskTitle = _addTaskBasedOnWeather(widget.weatherMain);
                Get.to(TaskAdd(), arguments: {
                  'title': taskTitle,
                  'description': _getWeatherDescription(widget.weatherMain),
                  'date': DateTime.now(),
                });
              },
              label: 'Add Task Based on Weather',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCelsius = !isCelsius;
                });
              },
              child: Text('Switch to ${isCelsius ? "Fahrenheit" : "Celsius"}'),
            ),
          ],
        ),
      ),
    );
  }

  String _addTaskBasedOnWeather(String weatherMain) {
    String taskTitle;

    switch (weatherMain.toLowerCase()) {
      case 'rain':
        taskTitle = 'Bring Umbrella';
        break;
      case 'clear':
        taskTitle = 'Enjoy some time outside';
        break;
      case 'snow':
        taskTitle = 'Dress warm';
        break;
      case 'thunderstorm':
        taskTitle = 'Cancel plans';
        break;
      default:
        taskTitle = 'Put on Sunscreen';
        break;
    }

    // Show a snackbar or toast to indicate the task was added
    Get.snackbar(
      'Hint',
      taskTitle,
      snackPosition: SnackPosition.TOP,
    );
    return taskTitle;
  }

  String _getWeatherDescription(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return "The weather is clear and sunny today. It's a perfect day to go outside and enjoy some outdoor activities.";
      case 'clouds':
        return 'The sky is partially covered with clouds. You might want to carry an umbrella just in case it rains.';
      case 'rain':
        return "It's raining today. Don't forget to bring your umbrella or raincoat when you go outside.";
      case 'thunderstorm':
        return "There is a thunderstorm in the area. Stay indoors and avoid going outside until it passes.";
      case 'snow':
        return "It's snowing today. Bundle up in warm clothes and enjoy the snowy weather.";
      default:
        return 'The weather is currently $weatherMain. Check back later for more updates.';
    }
  }
}
