import 'package:flutter/material.dart';
import 'package:outfitball/models/user_profile.dart';
import 'game_input_screen.dart';

class UserInputScreen extends StatefulWidget {
  @override
  _UserInputScreenState createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final _formKey = GlobalKey<FormState>();
  
  double _height = 175;
  double _weight = 70;
  String _gender = '남성';
  double _age = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 정보 입력'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person,
                size: 80,
                color: Colors.green[700],
              ),
              SizedBox(height: 24),
              Text(
                '신체 정보를 입력해주세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              
              _buildSlider(
                '키 (cm)',
                _height,
                10,
                300,
                (val) => setState(() => _height = val),
              ),
              SizedBox(height: 16),
              
              _buildSlider(
                '몸무게 (kg)',
                _weight,
                10,
                300,
                (val) => setState(() => _weight = val),
              ),
              SizedBox(height: 16),
              
              _buildSlider(
                '나이',
                _age,
                1,
                100,
                (val) => setState(() => _age = val),
              ),
              SizedBox(height: 24),
              
              Text(
                '성별',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: '남성', label: Text('남성'), icon: Icon(Icons.male)),
                  ButtonSegment(value: '여성', label: Text('여성'), icon: Icon(Icons.female)),
                ],
                selected: {_gender},
                onSelectionChanged: (Set<String> selected) {
                  setState(() => _gender = selected.first);
                },
              ),
              SizedBox(height: 48),
              
              ElevatedButton(
                onPressed: _goToGameInput,
                child: Text(
                  '다음',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toInt()}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _goToGameInput() {
    UserProfile profile = UserProfile(
      height: _height,
      weight: _weight,
      gender: _gender,
      age: _age.toInt(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameInputScreen(userProfile: profile),
      ),
    );
  }
}