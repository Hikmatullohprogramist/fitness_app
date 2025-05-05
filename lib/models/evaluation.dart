class Evaluation {
  final DateTime date;
  final Map<String, int> answers;
  final String? notes;
  final double overallScore;

  Evaluation({
    required this.date,
    required this.answers,
    this.notes,
    required this.overallScore,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'answers': answers,
        'notes': notes,
        'overallScore': overallScore,
      };

  factory Evaluation.fromJson(Map<String, dynamic> json) => Evaluation(
        date: DateTime.parse(json['date']),
        answers: Map<String, int>.from(json['answers']),
        notes: json['notes'],
        overallScore: json['overallScore'],
      );
}
