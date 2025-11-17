class WeatherData {
  final int temperature;
  final String condition;
  final double windSpeed;
  final int humidity;
  final int rainfall; // 강수 여부 (0: false, 1: true)
  final String skyCode;
  final String ptyCode;
  final DateTime forecastDateTime;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    required this.humidity,
    required this.rainfall,
    this.skyCode = '3',
    this.ptyCode = '0',
    DateTime? forecastDateTime,
  }) : forecastDateTime = forecastDateTime ?? DateTime.now();

  factory WeatherData.fromApiResponse(
    Map<String, dynamic> apiData,
    DateTime targetDate,
  ) {
    int temperature = 10;
    String skyCode = '3';
    String ptyCode = '0';
    double windSpeed = 0.0;
    int humidity = 60;
    
    temperature = apiData['temperature'] ?? 10;
    skyCode = apiData['sky'] ?? '3';
    ptyCode = apiData['pty'] ?? '0';
    windSpeed = apiData['windSpeed'] ?? 0.0;
    humidity = apiData['humidity'] ?? 60;
    
    String condition = _convertToCondition(ptyCode, skyCode);
    int rainfall = ptyCode != '0' ? 1 : 0;
    
    return WeatherData(
      temperature: temperature,
      condition: condition,
      windSpeed: windSpeed,
      humidity: humidity,
      rainfall: rainfall,
      skyCode: skyCode,
      ptyCode: ptyCode,
      forecastDateTime: targetDate,
    );
  }

  static String _convertToCondition(String ptyCode, String skyCode) {
    switch (ptyCode) {
      case '1':
        return '비';
      case '2':
        return '비/눈';
      case '3':
        return '눈';
      case '4':
        return '소나기';
    }
    
    switch (skyCode) {
      case '1':
        return '맑음';
      case '3':
        return '구름많음';
      case '4':
        return '흐림';
      default:
        return '흐림';
    }
  }

  String get weatherEmoji {
    if (ptyCode == '1' || ptyCode == '4') return '🌧️';
    if (ptyCode == '2') return '🌨️';
    if (ptyCode == '3') return '❄️';
    if (skyCode == '1') return '☀️';
    if (skyCode == '3') return '⛅';
    if (skyCode == '4') return '☁️';
    return '🌤️';
  }

  Map<String, dynamic> toJson() => {
    'temperature': temperature,
    'condition': condition,
    'windSpeed': windSpeed,
    'humidity': humidity,
    'rainfall': rainfall,
    'skyCode': skyCode,
    'ptyCode': ptyCode,
    'forecastDateTime': forecastDateTime.toIso8601String(),
  };

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
    temperature: json['temperature'],
    condition: json['condition'],
    windSpeed: json['windSpeed'],
    humidity: json['humidity'],
    rainfall: json['rainfall'],
    skyCode: json['skyCode'] ?? '3',
    ptyCode: json['ptyCode'] ?? '0',
    forecastDateTime: json['forecastDateTime'] != null 
        ? DateTime.parse(json['forecastDateTime'])
        : DateTime.now(),
  );
}