class LevelDayResponse {
  final bool success;
  final String message;
  final LevelData data;

  LevelDayResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LevelDayResponse.fromJson(Map<String, dynamic> json) {
    return LevelDayResponse(
      success: json['success'],
      message: json['message'],
      data: LevelData.fromJson(json['data']),
    );
  }
}

class LevelData {
  final LevelInfo level;
  final List<LevelDay> days;

  LevelData({
    required this.level,
    required this.days,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      level: LevelInfo.fromJson(json['level']),
      days: (json['days'] as List).map((e) => LevelDay.fromJson(e)).toList(),
    );
  }
}

class LevelInfo {
  final int id;
  final String name;
  final String timeRegulation;
  final String time;

  LevelInfo({
    required this.id,
    required this.name,
    required this.timeRegulation,
    required this.time,
  });

  factory LevelInfo.fromJson(Map<String, dynamic> json) {
    return LevelInfo(
      id: json['id'],
      name: json['name'],
      timeRegulation: json['time_regulation'],
      time: json['time'],
    );
  }
}

class LevelDay {
  final int id;
  final int levelId;
  final String name;
  final String duration;
  final String createdAt;
  final String updatedAt;
  final List<SubCategory> subCategories;

  LevelDay({
    required this.id,
    required this.levelId,
    required this.name,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    required this.subCategories,
  });

  factory LevelDay.fromJson(Map<String, dynamic> json) {
    return LevelDay(
      id: json['id'],
      levelId: json['level_id'],
      name: json['name'],
      duration: json['duration'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subCategories: (json['sub_categories'] as List)
          .map((e) => SubCategory.fromJson(e))
          .toList(),
    );
  }
}

class SubCategory {
  final int id;
  final int categoryId;
  final String name;
  final String createdAt;
  final String updatedAt;
  final Pivot pivot;

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pivot: Pivot.fromJson(json['pivot']),
    );
  }
}

class Pivot {
  final int dayId;
  final int subCategoryId;
  final String? duration;
  final String createdAt;
  final String updatedAt;

  Pivot({
    required this.dayId,
    required this.subCategoryId,
    this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      dayId: json['day_id'],
      subCategoryId: json['sub_category_id'],
      duration: json['duration']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
