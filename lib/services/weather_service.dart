import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:outfitball/models/weather_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static String get _serviceKey => dotenv.env['WEATHER_API_KEY'] ?? '';
  static const String _baseUrl = 'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst';
  
  Future<WeatherData> fetchWeather(int nx, int ny) async {
    try {
      Map<String, String> baseDateTime = _getBaseDateTime();
      
      final queryParameters = {
        'serviceKey': _serviceKey,
        'pageNo': '1',
        'numOfRows': '1000',
        'dataType': 'JSON',
        'base_date': baseDateTime['base_date']!,
        'base_time': baseDateTime['base_time']!,
        'nx': nx.toString(),
        'ny': ny.toString(),
      };
      
      final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParameters);
      print('API 호출: $uri');
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['response']['header']['resultCode'] == '00') {
          return _parseWeatherData(jsonData);
        } else {
          print('API Error: ${jsonData['response']['header']['resultMsg']}');
          return _getDemoData();
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        return _getDemoData();
      }
    } catch (e) {
      print('Weather API Error: $e');
      return _getDemoData();
    }
  }
  
  Map<String, String> _getBaseDateTime() {
    List<String> baseTimes = ['0200', '0500', '0800', '1100', '1400', '1700', '2000', '2300'];
    
    DateTime now = DateTime.now();
    String baseDate = DateFormat('yyyyMMdd').format(now);
    String baseTime = '0200';
    
    int currentHour = now.hour;
    int currentMinute = now.minute;
    
    if (currentHour < 2 || (currentHour == 2 && currentMinute < 10)) {
      DateTime yesterday = now.subtract(Duration(days: 1));
      baseDate = DateFormat('yyyyMMdd').format(yesterday);
      baseTime = '2300';
    } else {
      for (int i = baseTimes.length - 1; i >= 0; i--) {
        int baseHour = int.parse(baseTimes[i].substring(0, 2));
        if (currentHour > baseHour || (currentHour == baseHour && currentMinute >= 10)) {
          baseTime = baseTimes[i];
          break;
        }
      }
    }
    
    return {
      'base_date': baseDate,
      'base_time': baseTime,
    };
  }
  
  WeatherData _parseWeatherData(Map<String, dynamic> jsonData) {
    List<dynamic> items = jsonData['response']['body']['items']['item'];
    
    DateTime now = DateTime.now();
    String targetDateStr = DateFormat('yyyyMMdd').format(now);
    String targetTime = '1200';
    
    Map<String, dynamic> weatherMap = {
      'temperature': 10,
      'sky': '3',
      'pty': '0',
      'windSpeed': 0.0,
      'humidity': 60,
    };
    
    for (var item in items) {
      if (item['fcstDate'] == targetDateStr && item['fcstTime'] == targetTime) {
        String category = item['category'];
        String value = item['fcstValue'];
        
        switch (category) {
          case 'TMP':
            weatherMap['temperature'] = int.tryParse(value) ?? 10;
            break;
          case 'SKY':
            weatherMap['sky'] = value;
            break;
          case 'PTY':
            weatherMap['pty'] = value;
            break;
          case 'WSD':
            weatherMap['windSpeed'] = double.tryParse(value) ?? 0.0;
            break;
          case 'REH':
            weatherMap['humidity'] = int.tryParse(value) ?? 60;
            break;
        }
      }
    }
    
    return WeatherData.fromApiResponse(weatherMap, now);
  }
  
  WeatherData _getDemoData() {
    return WeatherData(
      temperature: 10,
      condition: '흐림',
      windSpeed: 2.5,
      humidity: 60,
      rainfall: 0,
    );
  }
}
