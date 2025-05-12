import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseAssessmentService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';

  Future<Map<String, dynamic>> getAssessments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercise-assessments'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get assessments');
      }
    } catch (e) {
      throw Exception('Error getting assessments: $e');
    }
  }

  Future<Map<String, dynamic>> createAssessment({
    required int exerciseId,
    required String rating,
    required String comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/exercise-assessments'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'exercise_id': exerciseId.toString(),
          'rating': rating,
          'comment': comment,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create assessment');
      }
    } catch (e) {
      throw Exception('Error creating assessment: $e');
    }
  }

  Future<Map<String, dynamic>> getAssessment(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercise-assessments/$id'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get assessment');
      }
    } catch (e) {
      throw Exception('Error getting assessment: $e');
    }
  }

  Future<Map<String, dynamic>> getAssessmentStats(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercise-assessments/stats/$id'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get assessment stats');
      }
    } catch (e) {
      throw Exception('Error getting assessment stats: $e');
    }
  }
}
