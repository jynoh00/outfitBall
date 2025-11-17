class GameInfo {
  final String location;
  final int nx;
  final int ny;
  final double fieldLength;
  final double fieldWidth;
  final int playerCount;
  final String position;
  final double playTime;

  GameInfo({
    required this.location,
    required this.nx,
    required this.ny,
    required this.fieldLength,
    required this.fieldWidth,
    required this.playerCount,
    required this.position,
    required this.playTime,
  });

  bool get isFutsal => playerCount <= 14;
  
  double get fieldSize => fieldLength * fieldWidth;

  Map<String, dynamic> toJson() => {
    'location': location,
    'nx': nx,
    'ny': ny,
    'fieldLength': fieldLength,
    'fieldWidth': fieldWidth,
    'playerCount': playerCount,
    'position': position,
    'playTime': playTime,
  };

  factory GameInfo.fromJson(Map<String, dynamic> json) => GameInfo(
    location: json['location'],
    nx: json['nx'],
    ny: json['ny'],
    fieldLength: json['fieldLength'],
    fieldWidth: json['fieldWidth'],
    playerCount: json['playerCount'],
    position: json['position'],
    playTime: json['playTime'],
  );
}