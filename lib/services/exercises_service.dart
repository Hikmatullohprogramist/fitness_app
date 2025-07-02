import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/models/exercies_model.dart';

class ExercisesService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getExercises(
      {int page = 1, int perPage = 10}) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/exersices?page=$page&per_page=$perPage'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedBody = json.decode(response.body);

        if (!decodedBody.containsKey('data')) {
          throw Exception('Invalid response format: data field not found');
        }

        final data = decodedBody['data'];
        List<Exercise> exercises = [];
        int currentPage = page;
        int lastPage = page;
        int total = 0;
        int perPageResult = perPage;

        if (data == null) {
          return {
            'exercises': [],
            'currentPage': 1,
            'lastPage': 1,
            'total': 0,
            'perPage': perPage
          };
        }

        if (data is Map && data.containsKey('data')) {
          final List exercisesList = data['data'];
          exercises = exercisesList.map((e) => Exercise.fromJson(e)).toList();
          currentPage = data['current_page'] ?? page;
          lastPage = data['last_page'] ?? page;
          total = data['total'] ?? exercises.length;
          perPageResult = data['per_page'] ?? perPage;
        } else if (data is List) {
          exercises = data.map((e) => Exercise.fromJson(e)).toList();
        }

        return {
          'exercises': exercises,
          'currentPage': currentPage,
          'lastPage': lastPage,
          'total': total,
          'perPage': perPageResult
        };
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
