class AuthModel {
  final String email;
  final String password;
  final String? name;

  AuthModel({
    required this.email,
    required this.password,
    this.name,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    if (name != null) {
      data['name'] = name;
    }
    return data;
  }
}
