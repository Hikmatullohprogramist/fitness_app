class User {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final String birthDate;
  final String gender;
  final double height;
  final double weight;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.phone,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'birthDate': birthDate,
        'gender': gender,
        'height': height,
        'weight': weight,
        'phone': phone,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        profileImageUrl: json['profileImageUrl'],
        birthDate: json['birthDate'],
        gender: json['gender'],
        height: json['height'],
        weight: json['weight'],
        phone: json['phone'],
      );
}
