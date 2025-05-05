class Workout {
  final DateTime date;
  final String type;
  final int durationMinutes;
  final double caloriesBurned;
  final String? notes;
  final List<Exercise> exercises;

  Workout({
    required this.date,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.notes,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'type': type,
        'durationMinutes': durationMinutes,
        'caloriesBurned': caloriesBurned,
        'notes': notes,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        date: DateTime.parse(json['date']),
        type: json['type'],
        durationMinutes: json['durationMinutes'],
        caloriesBurned: json['caloriesBurned'],
        notes: json['notes'],
        exercises: (json['exercises'] as List)
            .map((e) => Exercise.fromJson(e))
            .toList(),
      );
}

class Exercise {
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final String? notes;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sets': sets,
        'reps': reps,
        'weight': weight,
        'notes': notes,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        name: json['name'],
        sets: json['sets'],
        reps: json['reps'],
        weight: json['weight'],
        notes: json['notes'],
      );
}
