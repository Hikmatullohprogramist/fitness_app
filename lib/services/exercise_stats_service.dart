import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseStatsService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';

  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-stats'),
        headers: {
          'Accept-Charset': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get user stats');
      }
    } catch (e) {
      throw Exception('Error getting user stats: $e');
    }
  }

  Future<Map<String, dynamic>> getDailyStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/daily-stats'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get daily stats');
      }
    } catch (e) {
      throw Exception('Error getting daily stats: $e');
    }
  }

  Future<Map<String, dynamic>> doExercise({
    required int exerciseId,
    required int duration,
    required int repetitions,
    required int distance,
    required String rating,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/exercise-stats'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'exercise_id': exerciseId.toString(),
          'duration': duration.toString(),
          'repetitions': repetitions.toString(),
          'distance': distance.toString(),
          'rating': rating,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to record exercise');
      }
    } catch (e) {
      throw Exception('Error recording exercise: $e');
    }
  }

  Future<Map<String, dynamic>> getWeeklyStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weekly-stats'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get weekly stats');
      }
    } catch (e) {
      throw Exception('Error getting weekly stats: $e');
    }
  }

  Future<Map<String, dynamic>> getExercisePerformance(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercise-performance/$id'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get exercise performance');
      }
    } catch (e) {
      throw Exception('Error getting exercise performance: $e');
    }
  }
}
