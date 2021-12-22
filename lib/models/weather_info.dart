class WeatherInfo {
  late final String location;
  late final String weather;
  late final double temperature;
  late final double tempMin;
  late final double tempMax;
  late final double? windSpeed;
  late final int? humidity;

  WeatherInfo({
    required this.location,
    required this.weather,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.windSpeed,
    required this.humidity,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      location: json['name'],
      temperature: json['main']['temp'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      weather: json['weather'][0]['description'],
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: json['wind']['speed'] ?? 0,
    );
  }
}
