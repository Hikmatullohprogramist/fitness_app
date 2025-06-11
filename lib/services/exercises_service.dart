import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/models/exercies_model.dart';
import 'package:path/path.dart' as path;

class ExercisesService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';
  final AuthService _authService = AuthService();
  Future<List<Exercise>> getExercises() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/exersices'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedBody = json.decode(response.body);

        // Check if response has data property
        if (!decodedBody.containsKey('data')) {
          throw Exception('Invalid response format: data field not found');
        }

        final data = decodedBody['data'];

        // Check if data is null
        if (data == null) {
          return [];
        }

        // Handle paginated response structure
        if (data is Map && data.containsKey('data')) {
          final List exercisesList = data['data'];
          return exercisesList.map((e) => Exercise.fromJson(e)).toList();
        }

        // Handle direct list response
        if (data is List) {
          return data.map((e) => Exercise.fromJson(e)).toList();
        }

        throw Exception('Invalid response format: unexpected data structure');
      } else {
        throw Exception('Failed to get exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting exercises: $e');
    }
  }

  Future<Map<String, dynamic>> getExercise(int id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/exercise/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get exercise');
      }
    } catch (e) {
      throw Exception('Error getting exercise: $e');
    }
  }




}
