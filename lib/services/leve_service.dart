import 'package:fitness_app/models/level_model.dart';
import 'package:dio/dio.dart';
import 'auth_service.dart';

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
}
