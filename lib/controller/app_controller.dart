import 'package:flutter/material.dart';
import 'package:outfitball/models/game_info.dart';
import 'package:outfitball/models/user_profile.dart';
import 'package:outfitball/models/weather_data.dart';
import 'package:outfitball/models/outfit_recommendation.dart';
import 'package:outfitball/services/weather_service.dart';
import 'package:outfitball/services/outfit_calculator.dart';

class AppController extends ChangeNotifier {
  UserProfile? _userProfile;
  GameInfo? _gameInfo;
  WeatherData? _weatherData;
  OutfitRecommendation? _recommendation;

  final WeatherService _weatherService = WeatherService();
  final OutfitCalculator _outfitCalculator = OutfitCalculator();

  UserProfile? get userProfile => _userProfile;
  GameInfo? get gameInfo => _gameInfo;
  WeatherData? get weatherData => _weatherData;
  OutfitRecommendation? get recommendation => _recommendation;

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void setGameInfo(GameInfo info) {
    _gameInfo = info;
    notifyListeners();
  }

  Future<void> fetchWeatherAndCalculate() async {
    if (_gameInfo == null || _userProfile == null) {
      throw Exception('User profile and game info must be set first');
    }

    _weatherData = await _weatherService.fetchWeather(
      _gameInfo!.nx, 
      _gameInfo!.ny
    );
    
    _recommendation = _outfitCalculator.calculateOutfit(
      weather: _weatherData!,
      gameInfo: _gameInfo!,
      userProfile: _userProfile!,
    );

    notifyListeners();
  }

  void reset() {
    _userProfile = null;
    _gameInfo = null;
    _weatherData = null;
    _recommendation = null;
    notifyListeners();
  }
}