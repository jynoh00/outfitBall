import 'package:outfitball/models/weather_data.dart';
import 'package:outfitball/models/game_info.dart';
import 'package:outfitball/models/user_profile.dart';
import 'package:outfitball/models/outfit_recommendation.dart';
import 'package:outfitball/services/exercise_calculator.dart';

class OutfitCalculator {
  final ExerciseCalculator _exerciseCalculator = ExerciseCalculator();

  OutfitRecommendation calculateOutfit({
    required WeatherData weather,
    required GameInfo gameInfo,
    required UserProfile userProfile,
  }) {
    double exerciseIntensity = _exerciseCalculator.calculateIntensity(
      gameInfo: gameInfo,
      userProfile: userProfile,
    );

    double feltTemp = _calculateFeltTemperature(
      actualTemp: weather.temperature.toDouble(),
      exerciseIntensity: exerciseIntensity,
      windSpeed: weather.windSpeed,
      humidity: weather.humidity,
    );

    return _generateRecommendation(
      feltTemperature: feltTemp,
      weather: weather,
      exerciseIntensity: exerciseIntensity,
    );
  }

  double _calculateFeltTemperature({
    required double actualTemp,
    required double exerciseIntensity,
    required double windSpeed,
    required int humidity,
  }) {
    double bodyTempIncrease = _calculateMetabolicHeatEffect(exerciseIntensity);
    double windChillEffect = _calculateWindChillEffect(actualTemp, windSpeed);
    double humidityEffect = _calculateHumidityEffect(actualTemp, humidity, exerciseIntensity);
    
    double feltTemp = actualTemp + bodyTempIncrease - windChillEffect + humidityEffect;

    return feltTemp;
  }

  double _calculateMetabolicHeatEffect(double exerciseIntensity) {
    double metabolicHeatEffect = 3.5 + ((exerciseIntensity - 1.5) * 4.0); // 1.5 이상 초고강도

    if (exerciseIntensity < 0.5) metabolicHeatEffect = 0.5 + (exerciseIntensity * 1.0);
    if (exerciseIntensity < 0.8) metabolicHeatEffect = 1.0 + ((exerciseIntensity - 0.5) * 2.0);
    if (exerciseIntensity < 1.0) metabolicHeatEffect = 1.5 + ((exerciseIntensity - 0.8) * 2.0);
    if (exerciseIntensity < 1.2) metabolicHeatEffect = 2.0 + ((exerciseIntensity - 1.0) * 2.5);
    if (exerciseIntensity < 1.5) metabolicHeatEffect = 2.5 + ((exerciseIntensity - 1.2) * 3.0);

    return metabolicHeatEffect;
  }

  double _calculateWindChillEffect(double actualTemp, double windSpeed) {
    if (windSpeed < 1.0) return 0.0;
  
    double tempFactor = actualTemp < 10 ? 0.8 : 0.5;
    double windEffect = windSpeed * tempFactor;

    return windEffect > 6.0 ? 6.0 : windEffect;
  }

  double _calculateHumidityEffect(double actualTemp, int humidity, double exerciseIntensity) {
    if (actualTemp < 20) return 0.0;
    if (humidity < 70) return 0.0;
    
    double humidityFactor = (humidity - 70) / 10.0;  // 70%부터 10%당 +1
    double intensityFactor = exerciseIntensity > 1.0 ? 1.5 : 1.0;
    
    double humidityEffect = humidityFactor * intensityFactor * 0.5;
    return humidityEffect > 3.0 ? 3.0 : humidityEffect;
  }

  OutfitRecommendation _generateRecommendation({
    required double feltTemperature,
    required WeatherData weather,
    required double exerciseIntensity,
  }) {
    List<String> outfit = [];
    String description = '';
    String reasoning = '';

    if (feltTemperature < 0) {
      outfit = ['방한 바람막이', '긴팔 기능성 티셔츠', '레깅스 + 반바지', '목토시', '장갑'];
      description = '매우 추운 날씨입니다. 충분한 보온이 필요합니다.';
      reasoning = '실제 기온 ${weather.temperature}°C, 체감 온도 ${feltTemperature.toInt()}°C입니다.';
    }
    else if (feltTemperature < 10) {
      outfit = ['방한 바람막이', '긴팔 기능성 티셔츠', '레깅스 + 반바지'];
      description = '추운 날씨입니다. 보온이 필요합니다.';
      reasoning = '실제 기온 ${weather.temperature}°C, 체감 온도 ${feltTemperature.toInt()}°C입니다.';
    } else if (feltTemperature < 15) {
      outfit = ['바람막이', '긴팔 기능성 티셔츠', '긴 바지'];
      description = '쌀쌀하지만 운동량을 고려하면 적당합니다.';
      reasoning = '실제 기온 ${weather.temperature}°C, 체감 온도 ${feltTemperature.toInt()}°C입니다.';
    } else if (feltTemperature < 20) {
      outfit = ['얇은 바람막이', '기능성 반팔 티셔츠', '얇은 긴 바지'];
      description = '운동하기 좋은 날씨입니다.';
      reasoning = '실제 기온 ${weather.temperature}°C, 체감 온도 ${feltTemperature.toInt()}°C입니다.';
    } else if (feltTemperature < 25) {
      outfit = ['기능성 반팔 티셔츠', '반바지'];
      description = '따뜻한 날씨로 가볍게 입으세요.';
      reasoning = '실제 기온 ${weather.temperature}°C, 체감 온도 ${feltTemperature.toInt()}°C입니다.';
    } else if (feltTemperature < 30) {
      outfit = ['통풍이 잘 되는 반팔 티셔츠', '얇은 반바지'];
      description = '더운 날씨입니다. 시원하게 입고 수분 섭취에 신경쓰세요.';
      reasoning = '실제 기온 ${weather.temperature}°C, 체감 온도 ${feltTemperature.toInt()}°C입니다.';
    } else {
      outfit = ['통풍이 잘 되는 반팔 티셔츠', '얇은 반바지', '쿨링 타월'];
      description = '매우 더운 날씨입니다. 열사병 주의가 필요합니다.';
      reasoning = '실제 기온 ${weather.temperature}°C, 체감 온도 ${feltTemperature.toInt()}°C입니다.';
    }

    if (weather.rainfall > 0) {
      outfit.insert(0, '방수 옷');
      description += ' 비가 예상되니 방수 준비를 하세요.';
    }

    if (weather.humidity >= 80 && feltTemperature >= 25) {
      description += ' 고습도 환경으로 체온 조절이 어려울 수 있습니다.';
      reasoning += ' 습도 ${weather.humidity}%로 땀 증발이 억제되어 더 덥게 느껴질 수 있습니다.';
    }

    return OutfitRecommendation(
      items: outfit,
      description: description,
      feltTemperature: feltTemperature,
      reasoning: reasoning,
    );
  }
}
