class RegisterModel {
  final String email;
  final String password;
  final String name;
  final String gender;
  final String birthDate;
  final double height;
  final double weight;
  final String fitnessLevel;
  final String phone;
  final String? otm;
  final String? type;
  final int? course;

  RegisterModel({
    required this.email,
    required this.password,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.height,
    required this.weight,
    required this.fitnessLevel,
    required this.phone,
    this.otm,
    this.type,
    this.course,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'gender': gender,
      'birth_date': birthDate,
      'height': height,
      'weight': weight,
      'fitness_level': fitnessLevel,
      'phone': phone,
      'otm': otm,
      'type': type,
      'course': course,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birth_date'],
      height: double.parse(json['height'].toString()),
      weight: double.parse(json['weight'].toString()),
      fitnessLevel: json['fitness_level'],
      phone: json['phone'],
      otm: json['otm'],
      type: json['type'],
      course:
          json['course'] != null ? int.parse(json['course'].toString()) : null,
    );
  }
}
