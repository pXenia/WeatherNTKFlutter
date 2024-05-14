class WeatherData {
  final String name;
  final Main main;
  final List<Weather> weather;

  WeatherData({required this.name, required this.main, required this.weather});

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
    name: json["name"],
    main: Main.fromJson(json["main"]),
    weather: List<Weather>.from(
        json["weather"].map((x) => Weather.fromJson(x))),
  );
}

class Main {
  final double temp;
  final int pressure;
  final int humidity;

  Main({required this.temp, required this.pressure, required this.humidity});

  factory Main.fromJson(Map<String, dynamic> json) => Main(
    temp: json["temp"],
    pressure: json["pressure"],
    humidity: json["humidity"],
  );
}

class Weather {
  final String icon;
  Weather({required this.icon});
  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    icon: json["icon"],
  );
}