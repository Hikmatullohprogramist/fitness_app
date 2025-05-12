import 'dart:convert';
import 'package:http/http.dart' as http;

class ExercisesService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';

  Future<Map<String, dynamic>> getExercises() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exersices'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get exercises');
      }
    } catch (e) {
      throw Exception('Error getting exercises: $e');
    }
  }

  Future<Map<String, dynamic>> getExercise(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercise/$id'),
        headers: {
          'Accept': 'application/json',
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
