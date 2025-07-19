import 'package:fitness_app/models/day_subcategory.dart';
import 'package:fitness_app/models/level_model.dart';
import 'package:dio/dio.dart';
import 'package:fitness_app/models/sub_category_exercoes.dart';
import 'auth_service.dart';
import 'package:fitness_app/models/level_day_response.dart';

class LevelService {
  final AuthService _authService = AuthService();

  Dio get _dio => Dio(
        BaseOptions(
          baseUrl: AuthService.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
  Future<LevelResponse> getLevels() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await _dio.get(
        "${AuthService.baseUrl}/levels",
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return LevelResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to get levels: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting levels: $e');
    }
  }

  Future<LevelDayResponse> getLevelDays(int levelId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await _dio.get(
        "${AuthService.baseUrl}/levels/$levelId/days",
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return LevelDayResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to get level days: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting level days: $e');
    }
  }

  Future<DaySubCategoriesResponse> getDaySubCategories(
      int dayId, int levelId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await _dio.get(
        "${AuthService.baseUrl}/levels/$levelId/days/$dayId/sub-categories",
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return DaySubCategoriesResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to get day sub categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting day sub categories: $e');
    }
  }

  Future<SubCategoryExercisesResponse> getSubCategoryExercises(
      int subCategoryId, int levelId, int dayId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final url =
          "${AuthService.baseUrl}/levels/$levelId/days/$dayId/sub-categories/$subCategoryId/exercises";
      print('Making API call to: $url'); // Debug print

      final response = await _dio.get(
        url,
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      print('API Response status: ${response.statusCode}'); // Debug print
      print('API Response data: ${response.data}'); // Debug print

      if (response.statusCode == 200 && response.data["success"] == true) {
        final result = SubCategoryExercisesResponse.fromJson(response.data);
        print(
            'Parsed exercises count: ${result.data.exercises.length}'); // Debug print
        return result;
      } else {
        throw Exception(
            'Failed to get sub category exercises: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getSubCategoryExercises: $e'); // Debug print
      throw Exception('Error getting sub category exercises: $e');
    }
  }
}
