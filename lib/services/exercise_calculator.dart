import 'package:outfitball/models/game_info.dart';
import 'package:outfitball/models/user_profile.dart';

class ExerciseCalculator {
  static const Map<String, double> _futsalPositionIntensity = {
    'ALA': 1.09,
    'PIVOT': 0.98,
    'FIXO': 0.93,
    'GOLEIRO': 0.5,
  };

  static const Map<String, double> _soccerPositionIntensity = {
    'FW': 0.98,
    'MF': 1.09,
    'DF': 0.93,
    'GK': 0.5,
  };

  double calculateIntensity({
    required GameInfo gameInfo,
    required UserProfile userProfile,
  }) {
    Map<String, double> intensityMap = gameInfo.isFutsal 
        ? _futsalPositionIntensity 
        : _soccerPositionIntensity;

    int meanMapSize = gameInfo.isFutsal ? 900 : 6560; // 평균 규격
    
    double positionIntensity = intensityMap[gameInfo.position] ?? 1.0;
    double fieldFactor = gameInfo.fieldSize / meanMapSize;
    double timeFactor = gameInfo.playTime / 60;
    double fitnessFactor = userProfile.fitnessLevel;

    return positionIntensity * fieldFactor * timeFactor * fitnessFactor;
  }
}