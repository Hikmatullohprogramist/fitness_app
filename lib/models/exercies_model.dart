// success: true, message: Exercises retrieved successfully, data: {current_page: 1, data: [{id: 5, name: Team exercies, duration: 20, category_ids: null, created_at: 2025-05-21T04:00:56.000000Z, updated_at: 2025-05-21T04:00:56.000000Z, description: asdasdas, vacation_time: 20, count: 200, media: [{id: 5, model_type: App\Models\Exercise, model_id: 5, uuid: 23a919b1-41ad-4dc7-90a3-32d6dbdd4d2c, collection_name: media, name: 12, file_name: 01JVRG0RB0VTAQM09TJ4228HVW.png, mime_type: image/png, disk: public, conversions_disk: public, size: 590762, manipulations: [], custom_properties: [], generated_conversions: {thumb: true, preview: true}, responsive_images: [], order_column: 1, created_at: 2025-05-21T04:00:56.000000Z, updated_at: 2025-05-21T04:00:56.000000Z, original_url: https://fitnes.bizsoft.uz/storage/5/01JVRG0RB0VTAQM09TJ4228HVW.png, preview_url: https://fitnes.bizsoft.uz/storage/5/conversions/01JVRG0RB0VTAQM09TJ4228HVW-preview.jpg}], categories: [{id: 2, name: Jamoaviy mashqlar , created_at: 2025-05-14T05
class Exercise {
  final int id;
  final String name;
  final String duration;
  final List<int>? categoryIds;
  final String createdAt;
  final String updatedAt;
  final String description;
  final String vacationTime;
  final String count;
  final List<Media> media;
  final List<Category> categories;

  Exercise({
    required this.id,
    required this.name,
    required this.duration,
    this.categoryIds,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.vacationTime,
    required this.count,
    required this.media,
    required this.categories,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      categoryIds: json['category_ids'] != null
          ? List<int>.from(json['category_ids'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      description: json['description'] ?? "",
      vacationTime: json['vacation_time'] ?? "",
      count: json['count'] ?? "",
      media: (json['media'] as List)
          .map((media) => Media.fromJson(media))
          .toList(),
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
    );
  }
}

class Media {
  final int id;
  final String modelType;
  final int modelId;
  final String uuid;
  final String collectionName;
  final String name;
  final String fileName;
  final String mimeType;
  final String disk;
  final String conversionsDisk;
  final int size;
  final String originalUrl;
  final String previewUrl;

  Media({
    required this.id,
    required this.modelType,
    required this.modelId,
    required this.uuid,
    required this.collectionName,
    required this.name,
    required this.fileName,
    required this.mimeType,
    required this.disk,
    required this.conversionsDisk,
    required this.size,
    required this.originalUrl,
    required this.previewUrl,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      modelType: json['model_type'],
      modelId: json['model_id'],
      uuid: json['uuid'],
      collectionName: json['collection_name'],
      name: json['name'],
      fileName: json['file_name'],
      mimeType: json['mime_type'],
      disk: json['disk'],
      conversionsDisk: json['conversions_disk'],
      size: json['size'],
      originalUrl: json['original_url'],
      previewUrl: json['preview_url'],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String createdAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
    );
  }
}
