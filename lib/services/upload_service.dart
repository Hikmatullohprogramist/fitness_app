import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UploadService {
  final String baseUrl;
  final String token;

  UploadService({
    required this.baseUrl,
    required this.token,
  });

  Future<bool> uploadJsonFile(File file, String category) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/exercises/upload'),
      );

      // Add authorization header
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: path.basename(file.path),
        ),
      );

      // Add category
      request.fields['category'] = category;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('File uploaded successfully: ${file.path}');
        return true;
      } else {
        print('Error uploading file: $responseBody');
        return false;
      }
    } catch (e) {
      print('Exception while uploading file: $e');
      return false;
    }
  }

  Future<bool> uploadDirectory(String directoryPath, String category) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        print('Directory does not exist: $directoryPath');
        return false;
      }

      final files = await directory.list().toList();
      int successCount = 0;
      int totalFiles = files.length;

      for (var file in files) {
        if (file is File && file.path.endsWith('.json')) {
          final success = await uploadJsonFile(file, category);
          if (success) successCount++;
        }
      }

      print(
          'Upload complete. Successfully uploaded $successCount out of $totalFiles files');
      return successCount > 0;
    } catch (e) {
      print('Error uploading directory: $e');
      return false;
    }
  }

  Future<bool> uploadAllExercises(String baseDirectory) async {
    try {
      final directory = Directory(baseDirectory);
      if (!await directory.exists()) {
        print('Base directory does not exist: $baseDirectory');
        return false;
      }

      final categories = await directory.list().toList();
      int successCount = 0;
      int totalCategories = categories.length;

      for (var category in categories) {
        if (category is Directory) {
          final categoryName = path.basename(category.path);
          final success = await uploadDirectory(category.path, categoryName);
          if (success) successCount++;
        }
      }

      print(
          'All uploads complete. Successfully uploaded $successCount out of $totalCategories categories');
      return successCount > 0;
    } catch (e) {
      print('Error uploading all exercises: $e');
      return false;
    }
  }
}
