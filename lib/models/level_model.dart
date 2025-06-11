class LevelResponse {
  final bool success;
  final String message;
  final LevelData data;

  LevelResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LevelResponse.fromJson(Map<String, dynamic> json) {
    return LevelResponse(
      success: json['success'],
      message: json['message'],
      data: LevelData.fromJson(json['data']),
    );
  }
}

class LevelData {
  final int currentPage;
  final List<Level> levels;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  LevelData({
    required this.currentPage,
    required this.levels,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      currentPage: json['current_page'],
      levels:
          (json['data'] as List).map((level) => Level.fromJson(level)).toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List)
          .map((link) => PageLink.fromJson(link))
          .toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class Level {
  final int id;
  final String name;
  final String timeRegulation;
  final String createdAt;
  final String updatedAt;
  final String time;

  Level({
    required this.id,
    required this.name,
    required this.timeRegulation,
    required this.createdAt,
    required this.updatedAt,
    required this.time,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      name: json['name'],
      timeRegulation: json['time_regulation'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      time: json['time'],
    );
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
