import 'package:flutter/material.dart';
import 'package:outfitball/models/user_profile.dart';
import 'package:outfitball/models/game_info.dart';
import 'package:outfitball/controller/app_controller.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final UserProfile userProfile;
  final GameInfo gameInfo;

  LoadingScreen({
    required this.userProfile,
    required this.gameInfo,
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    AppController controller = AppController();
    controller.setUserProfile(widget.userProfile);
    controller.setGameInfo(widget.gameInfo);
    
    await controller.fetchWeatherAndCalculate();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          userProfile: widget.userProfile,
          gameInfo: widget.gameInfo,
          weatherData: controller.weatherData!,
          recommendation: controller.recommendation!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              '날씨 정보를 가져오는 중...',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              '최적의 옷차림을 계산하고 있습니다',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
