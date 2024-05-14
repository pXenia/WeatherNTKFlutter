import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:weather_app_ntk_flutter/weather.dart';

void main() {
  runApp(const MyApp());
}

const apiKey = ""; //добавить API ключ с openweathermap.org
const baseUrl = "https://api.openweathermap.org/data/2.5/";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const WeatherAppScreen(),
    );
  }
}

class WeatherAppScreen extends StatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  _WeatherAppScreenState createState() => _WeatherAppScreenState();
}

class _WeatherAppScreenState extends State<WeatherAppScreen> {
  String cityName = "";
  WeatherData? weatherData;

  Future<WeatherData?> fetchWeatherData(String city) async {
    final url = Uri.parse("$baseUrl/weather?q=$city&appid=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Не удалось загрузить данные о погоде');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFE0E6F3),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: SizedBox(
              height: 60,
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.black54),
                  labelText: "Город",
                  prefix: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      try {
                        final weather = await fetchWeatherData(cityName);
                        setState(() => weatherData = weather);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ошибка!")),
                        );
                      }
                    },
                  ),
                ),
                onChanged: (text) => cityName = text,
              ),
            ),
          ),
          Expanded(
            child: weatherData != null
                ? WeatherCard(weatherData!)
                : const Center(child: Text('Нет данных о погоде')),
          ),
        ],
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherCard(this.weatherData, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0 , horizontal: 80.0),
          child: Image.asset("assets/p${weatherData.weather[0].icon.toString().substring(0,2)}d.png"),
        ),
        Text(
          "${weatherData.name} ${DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now())}",
          style: const TextStyle(fontSize: 20.0, color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                textAlign: TextAlign.center,
                "Температура:\n${(weatherData.main.temp.toInt() - 273)}°C",
              ),
              Text(
                textAlign: TextAlign.center,
                "Давление:\n${(weatherData.main.pressure * 0.75)} мм рт. ст",
              ),
              Text(
                textAlign: TextAlign.center,
                "Влажность:\n${weatherData.main.humidity}%",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
