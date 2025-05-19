import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitness_app/services/auth_service.dart';

class CategoriesService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getCategories() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/category'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get categories');
      }
    } catch (e) {
      throw Exception('Error getting categories: $e');
    }
  }
}
