import 'package:flutter/material.dart';
import 'package:outfitball/models/user_profile.dart';
import 'package:outfitball/models/game_info.dart';
import 'package:outfitball/services/location_service.dart';
import 'loading_screen.dart';

class GameInputScreen extends StatefulWidget {
  final UserProfile userProfile;

  GameInputScreen({required this.userProfile});

  @override
  _GameInputScreenState createState() => _GameInputScreenState();
}

class _GameInputScreenState extends State<GameInputScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _location = '서울';
  double _fieldLength = 40;
  double _fieldWidth = 22.5;
  double _playerCount = 12;
  String _position = 'ALA';
  double _playTime = 60;

  List<String> get _availablePositions {
    bool isFutsal = _playerCount <= 14;
    return isFutsal 
        ? ['ALA', 'PIVO', 'FIXO', 'GOLEIRO']
        : ['FW', 'MF', 'DF', 'GK'];
  }

  @override
  void initState() {
    super.initState();
    _position = _availablePositions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('경기 정보 입력'),
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
                Icons.sports_soccer,
                size: 80,
                color: Colors.green[700],
              ),
              SizedBox(height: 24),
              Text(
                '경기 정보를 입력해주세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              
              // 검색 가능한 위치 선택
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _location),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return LocationService.getAllLocations();
                  }
                  return LocationService.searchLocations(textEditingValue.text);
                },
                onSelected: (String selection) {
                  setState(() => _location = selection);
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: '경기 위치',
                      hintText: '지역을 검색하세요 (예: 서울 강남구)',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                      helperText: '현재 날씨 정보를 가져올 위치',
                    ),
                    onEditingComplete: onEditingComplete,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200, maxWidth: 400),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              title: Text(option),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _fieldLength.toString(),
                      decoration: InputDecoration(
                        labelText: '경기장 길이 (m)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        _fieldLength = double.tryParse(val) ?? 40;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _fieldWidth.toString(),
                      decoration: InputDecoration(
                        labelText: '경기장 너비 (m)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        _fieldWidth = double.tryParse(val) ?? 22.5;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              _buildSlider(
                '필드 인원 수',
                _playerCount,
                6,
                22,
                (val) {
                  setState(() {
                    _playerCount = val;
                    _position = _availablePositions[0];
                  });
                },
              ),
              Center(
                child: Text(
                  _playerCount <= 14 ? '풋살' : '축구',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _position,
                decoration: InputDecoration(
                  labelText: '포지션',
                  border: OutlineInputBorder(),
                ),
                items: _availablePositions.map((pos) {
                  return DropdownMenuItem(value: pos, child: Text(pos));
                }).toList(),
                onChanged: (val) {
                  setState(() => _position = val!);
                },
              ),
              SizedBox(height: 16),
              
              _buildSlider(
                '예상 플레이 시간 (분)',
                _playTime,
                30,
                120,
                (val) => setState(() => _playTime = val),
              ),
              SizedBox(height: 48),
              
              ElevatedButton(
                onPressed: _goToResult,
                child: Text(
                  '아웃핏 추천',
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

  void _goToResult() async {
    // 좌표 가져오기
    Map<String, int>? coordinates = LocationService.getCoordinates(_location);
    
    if (coordinates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('선택한 위치의 좌표를 찾을 수 없습니다')),
      );
      return;
    }

    GameInfo gameInfo = GameInfo(
      location: _location,
      nx: coordinates['nx']!,
      ny: coordinates['ny']!,
      fieldLength: _fieldLength,
      fieldWidth: _fieldWidth,
      playerCount: _playerCount.toInt(),
      position: _position,
      playTime: _playTime,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          userProfile: widget.userProfile,
          gameInfo: gameInfo,
        ),
      ),
    );
  }
}