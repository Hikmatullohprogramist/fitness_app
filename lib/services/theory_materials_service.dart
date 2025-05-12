import 'dart:convert';
import 'package:http/http.dart' as http;

class TheoryMaterialsService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';

  Future<Map<String, dynamic>> getMaterials() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/theory-materials'),
        headers: {
          'Accept': 'application/json',
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
      final response = await http.get(
        Uri.parse('$baseUrl/theory-materials/$id'),
        headers: {
          'Accept': 'application/json',
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
      final response = await http.get(
        Uri.parse('$baseUrl/theory-materials/$id/download'),
        headers: {
          'Accept': 'application/json',
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
