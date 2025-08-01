class DaySubCategoriesResponse {
  final bool success;
  final String message;
  final DaySubCategoriesData data;

  DaySubCategoriesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DaySubCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return DaySubCategoriesResponse(
      success: json['success'],
      message: json['message'],
      data: DaySubCategoriesData.fromJson(json['data']),
    );
  }
}

class DaySubCategoriesData {
  final LevelShort level;
  final DayShort day;
  final List<SubCategoryWithCategory> subCategories;

  DaySubCategoriesData({
    required this.level,
    required this.day,
    required this.subCategories,
  });

  factory DaySubCategoriesData.fromJson(Map<String, dynamic> json) {
    return DaySubCategoriesData(
      level: LevelShort.fromJson(json['level']),
      day: DayShort.fromJson(json['day']),
      subCategories: (json['sub_categories'] as List)
          .map((e) => SubCategoryWithCategory.fromJson(e))
          .toList(),
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

class SubCategoryWithCategory {
  final int id;
  final int categoryId;
  final String name;
  final String createdAt;
  final String updatedAt;
  final Pivot pivot;
  final Category category;

  SubCategoryWithCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
    required this.category,
  });

  factory SubCategoryWithCategory.fromJson(Map<String, dynamic> json) {
    return SubCategoryWithCategory(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pivot: Pivot.fromJson(json['pivot']),
      category: Category.fromJson(json['category']),
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
