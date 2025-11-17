class UserProfile {
  final double height;
  final double weight;
  final String gender;
  final int age;

  UserProfile({
    required this.height,
    required this.weight,
    required this.gender,
    required this.age,
  });

  double get bmi => weight / ((height / 100) * (height / 100));
  
  double get fitnessLevel {
    double bmiFactor = 1.0;
    if (bmi < 18.5) bmiFactor = 1.15;
    if (bmi > 25) bmiFactor = 1.15;
    
    double ageFactor = 1.0;
    if (age > 30) ageFactor = 1.15;
    if (age > 40) ageFactor = 1.3;
    if (age < 15) ageFactor = 1.15;
    
    return bmiFactor * ageFactor;
  }

  Map<String, dynamic> toJson() => {
    'height': height,
    'weight': weight,
    'gender': gender,
    'age': age,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    height: json['height'],
    weight: json['weight'],
    gender: json['gender'],
    age: json['age'],
  );
}