import 'package:flutter/material.dart';
import 'package:hydroponic_home/widget/humidity.dart';
import 'package:hydroponic_home/widget/thermometer.dart';
import 'package:hydroponic_home/widget/connection_status.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    int i = 0;
    // Hardcoded the maximum temperature and humidity possible that can be reached
    int maxValuePossible = 50;
    int maxHumPoss = 100; // this is in %

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              // Makes the image cover the entire background
              fit: BoxFit.cover,
            ),
          ),

          // Title at the top
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Welcome to Hydroponics App',
                style: TextStyle(
                  color: const Color.fromARGB(255, 6, 77, 110),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Thermometer widget
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1 + 40,
            left: MediaQuery.of(context).size.width * 0.33,
            width: MediaQuery.of(context).size.width * 0.40,
            height: MediaQuery.of(context).size.height * 0.3,
            child: GestureDetector(
              onTap: () => {print("temperaure")},
              child: Card(
                color: Colors.green.withOpacity(0.3),
                elevation: 1,
                child: Thermo(
                  duration: const Duration(milliseconds: 750),
                  color: i.isOdd
                      ? Colors.red
                      : const Color.fromARGB(255, 86, 153, 219),

                  // Display actual temperature value
                  maxValue: maxValuePossible.toDouble(),
                  value: i.isOdd ? 0.1 : 19.6 / maxValuePossible,

                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 0.1
                      ..color = Color.fromARGB(255, 6, 77, 110),
                  ),
                ),
              ),
            ),
          ),

          // Humidity widget
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1 +
                MediaQuery.of(context).size.height * 0.36,
            left: MediaQuery.of(context).size.width * 0.33,
            width: MediaQuery.of(context).size.width * 0.40,
            height: MediaQuery.of(context).size.height * 0.2,
            child: GestureDetector(
              onTap: () => {print("humidity")},
              child: Card(
                  color: Colors.green.withOpacity(0.3),
                  elevation: 1,
                  child: Humidity(
                    color: Colors.blue,
                    value: 0.752,
                    maxValue: maxHumPoss.toDouble(),
                    duration: Duration(seconds: 1),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.5
                        ..color = Color.fromARGB(255, 6, 77, 110),
                    ),
                  )),
            ),
          ),

          // Connection status widget
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1 +
                MediaQuery.of(context).size.height * 0.36 +
                MediaQuery.of(context).size.height * 0.19,
            left: MediaQuery.of(context).size.width * 0.33,
            width: MediaQuery.of(context).size.width * 0.40,
            height: MediaQuery.of(context).size.height * 0.05,
            child: Card(
              color: Colors.green.withOpacity(0.3),
              elevation: 1,
              child: ConnectionStatus(),
            ),
          ),

          // Subtitle at the bottom
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Designed and Developed by Federico Caporale',
                style: TextStyle(
                  color: const Color.fromARGB(255, 10, 103, 146),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
