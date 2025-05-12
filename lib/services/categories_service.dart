import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoriesService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';

  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/category'),
        headers: {
          'Accept': 'application/json',
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
