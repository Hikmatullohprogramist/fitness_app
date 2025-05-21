import 'dart:convert';
import 'package:fitness_app/models/register_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_model.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_info';

  Future<Map<String, dynamic>> login(AuthModel authModel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(authModel.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print(data);
        if (data['data'] != null) {
          print(data['data']['user']);
          final user = UserModel.fromJson(data['data']['user']);

          print(user is UserModel);
          final token = data['data']['token'];
          await _saveUserAndToken(user, token);
        }
        return data;
      } else {
        final error = json.decode(response.body);
        if (error['errors'] != null) {
          throw ValidationException(error['errors']);
        }
        throw Exception(error['message'] ?? 'Failed to login');
      }
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw Exception('Error during login: $e');
    }
  }

  Future<Map<String, dynamic>> register(RegisterModel authModel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(authModel.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          final user = UserModel.fromJson(data['data']['user']);
          final token = data['data']['token'];
          await _saveUserAndToken(user, token);
        }
        return data;
      } else {
        final error = json.decode(response.body);
        if (error['errors'] != null) {
          throw ValidationException(error['errors']);
        }
        throw Exception(error['message'] ?? 'Failed to register');
      }
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw Exception('Error during registration: $e');
    }
  }

  Future<void> _saveUserAndToken(UserModel user, String token) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userKey, value: json.encode(user.toJson()));
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(json.decode(userJson));
  }

  Future<void> updateUser(UserModel user) async {
    await _storage.write(key: _userKey, value: json.encode(user.toJson()));
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}

class ValidationException implements Exception {
  final Map<String, List<String>> errors;

  ValidationException(this.errors);

  @override
  String toString() {
    final errorMessages =
        errors.entries.map((e) => '${e.key}: ${e.value.join(", ")}').join('\n');
    return 'Validation failed:\n$errorMessages';
  }
}
