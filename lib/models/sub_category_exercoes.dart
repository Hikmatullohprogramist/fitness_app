import 'package:fitness_app/models/exercies_model.dart';

class SubCategoryExercisesResponse {
  final bool success;
  final String message;
  final SubCategoryExercisesData data;

  SubCategoryExercisesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SubCategoryExercisesResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryExercisesResponse(
      success: json['success'],
      message: json['message'],
      data: SubCategoryExercisesData.fromJson(json['data']),
    );
  }
}

class SubCategoryExercisesData {
  final LevelShort level;
  final DayShort day;
  final SubCategoryDetail subCategory;
  final List<Exercise> exercises;

  SubCategoryExercisesData({
    required this.level,
    required this.day,
    required this.subCategory,
    required this.exercises,
  });

  factory SubCategoryExercisesData.fromJson(Map<String, dynamic> json) {
    return SubCategoryExercisesData(
      level: LevelShort.fromJson(json['level']),
      day: DayShort.fromJson(json['day']),
      subCategory: SubCategoryDetail.fromJson(json['sub_category']),
      exercises:
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}

class LevelShort {
  final int id;
  final String name;

  LevelShort({
    required this.id,
    required this.name,
  });

  factory LevelShort.fromJson(Map<String, dynamic> json) {
    return LevelShort(
      id: json['id'],
      name: json['name'],
    );
  }
}

class DayShort {
  final int id;
  final String name;
  final String duration;

  DayShort({
    required this.id,
    required this.name,
    required this.duration,
  });

  factory DayShort.fromJson(Map<String, dynamic> json) {
    return DayShort(
      id: json['id'],
      name: json['name'],
      duration: json['duration'].toString(),
    );
  }
}

class SubCategoryDetail {
  final int id;
  final String name;
  final Category category;

  SubCategoryDetail({
    required this.id,
    required this.name,
    required this.category,
  });

  factory SubCategoryDetail.fromJson(Map<String, dynamic> json) {
    return SubCategoryDetail(
      id: json['id'],
      name: json['name'],
      category: Category.fromJson(json['category']),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String? icon;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      icon: json['icon'],
    );
  }
}
