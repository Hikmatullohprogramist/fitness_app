import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitness_app/services/auth_service.dart';

class TheoryMaterialsService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getMaterials() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/theory-materials'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get materials');
      }
    } catch (e) {
      throw Exception('Error getting materials: $e');
    }
  }

  Future<Map<String, dynamic>> getMaterial(int id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/theory-materials/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get material');
      }
    } catch (e) {
      throw Exception('Error getting material: $e');
    }
  }

  Future<http.Response> downloadMaterial(int id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/theory-materials/$id/download'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to download material');
      }
    } catch (e) {
      throw Exception('Error downloading material: $e');
    }
  }
}
