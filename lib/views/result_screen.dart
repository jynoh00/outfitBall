import 'package:flutter/material.dart';
import 'package:outfitball/models/user_profile.dart';
import 'package:outfitball/models/game_info.dart';
import 'package:outfitball/models/weather_data.dart';
import 'package:outfitball/models/outfit_recommendation.dart';
import 'splash_screen.dart';

class ResultScreen extends StatelessWidget {
  final UserProfile userProfile;
  final GameInfo gameInfo;
  final WeatherData weatherData;
  final OutfitRecommendation recommendation;

  ResultScreen({
    required this.userProfile,
    required this.gameInfo,
    required this.weatherData,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추천 결과'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOutfitCard(),
            SizedBox(height: 16),
            _buildWeatherCard(),
            SizedBox(height: 16),
            _buildGameInfoCard(),
            SizedBox(height: 16),
            _buildReasoningCard(),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              },
              icon: Icon(Icons.refresh),
              label: Text('새로 시작하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutfitCard() {
    return Card(
      color: Colors.green[50],
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.checkroom, size: 64, color: Colors.green[700]),
            SizedBox(height: 16),
            Text(
              '추천 옷차림',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            Divider(height: 32),
            ...recommendation.items.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                recommendation.description,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  weatherData.weatherEmoji,
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(width: 12),
                Text(
                  '날씨 정보',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            _buildInfoRow('위치', gameInfo.location),
            _buildInfoRow('기온', '${weatherData.temperature}°C'),
            _buildInfoRow('날씨', weatherData.condition),
            _buildInfoRow('풍속', '${weatherData.windSpeed.toStringAsFixed(1)} m/s'),
            _buildInfoRow('습도', '${weatherData.humidity}%'),
            if (weatherData.rainfall > 0)
              _buildInfoRow('강수', '예상됨', highlight: true),
            Divider(height: 24),
            _buildInfoRow('체감 온도', '${recommendation.feltTemperature.toInt()}°C', 
                highlight: true),
          ],
        ),
      ),
    );
  }

  Widget _buildGameInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sports_soccer, color: Colors.green[700]),
                SizedBox(width: 8),
                Text(
                  '경기 정보',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            _buildInfoRow('경기 위치', gameInfo.location),
            _buildInfoRow('경기장 크기', 
                '${gameInfo.fieldLength.toInt()}m × ${gameInfo.fieldWidth.toInt()}m'),
            _buildInfoRow('경기장 면적', '${gameInfo.fieldSize.toInt()}㎡'),
            _buildInfoRow('게임 타입', gameInfo.isFutsal ? '풋살' : '축구'),
            _buildInfoRow('인원 수', '${gameInfo.playerCount}명'),
            _buildInfoRow('포지션', gameInfo.position),
            _buildInfoRow('예상 시간', '${gameInfo.playTime.toInt()}분'),
          ],
        ),
      ),
    );
  }

  Widget _buildReasoningCard() {
    return Card(
      color: Colors.amber[50],
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber[700]),
                SizedBox(width: 8),
                Text(
                  '추천 이유',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            Text(
              recommendation.reasoning,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? Colors.green[700] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}