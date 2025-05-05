class JournalEntry {
  final DateTime date;
  final String note;
  final String? mood;
  final double? energyLevel;
  final List<String>? tags;

  JournalEntry({
    required this.date,
    required this.note,
    this.mood,
    this.energyLevel,
    this.tags,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'note': note,
        'mood': mood,
        'energyLevel': energyLevel,
        'tags': tags,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        date: DateTime.parse(json['date']),
        note: json['note'],
        mood: json['mood'],
        energyLevel: json['energyLevel'],
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      );
}
