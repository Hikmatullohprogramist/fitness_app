class UserModel {
  final int id;
  final String name;
  final String? gender;
  final String? birthDate;
  final String? otm;
  final String? type;
  final String? role;
  final String? course;
  final String? phone;
  final int height;
  final int weight;
  final int? fitnessLevel;
  final String? email;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    this.gender,
    this.birthDate,
    this.otm,
    this.type,
    this.role,
    this.course,
    this.phone,
    required this.height,
    required this.weight,
    this.fitnessLevel,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birth_date'],
      otm: json['otm'],
      type: json['type'],
      role: json['role'],
      course: json['course'],
      phone: json['phone'],
      height: json['height'],
      weight: json['weight'],
      fitnessLevel: json['fitness_level'] is String
          ? int.tryParse(json['fitness_level'])
          : json['fitness_level'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'birth_date': birthDate,
      'otm': otm,
      'type': type,
      'role': role,
      'course': course,
      'phone': phone,
      'height': height,
      'weight': weight,
      'fitness_level': fitnessLevel,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? gender,
    String? birthDate,
    String? otm,
    String? type,
    String? role,
    String? course,
    String? phone,
    int? height,
    int? weight,
    int? fitnessLevel,
    String? email,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      otm: otm ?? this.otm,
      type: type ?? this.type,
      role: role ?? this.role,
      course: course ?? this.course,
      phone: phone ?? this.phone,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, gender: $gender, birthDate: $birthDate, otm: $otm, type: $type, role: $role, course: $course, phone: $phone, height: $height, weight: $weight, fitnessLevel: $fitnessLevel, email: $email, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
