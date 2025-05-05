import 'package:hive/hive.dart';
import '../models/workout.dart';
import 'base_repository.dart';

class WorkoutRepository implements BaseRepository<Workout> {
  final Box<List> _box;

  WorkoutRepository(this._box);

  @override
  Future<void> save(Workout workout) async {
    final workouts = await getAll();
    workouts.add(workout);
    await _box.put('workouts', workouts.map((w) => w.toJson()).toList());
  }

  @override
  Future<Workout?> get(String id) async {
    final workouts = await getAll();
    return workouts.firstWhere((w) => w.date.toIso8601String() == id);
  }

  @override
  Future<List<Workout>> getAll() async {
    final data = _box.get('workouts');
    if (data == null) return [];
    return (data as List).map((w) => Workout.fromJson(w)).toList();
  }

  @override
  Future<void> update(Workout workout) async {
    final workouts = await getAll();
    final index = workouts.indexWhere((w) => w.date == workout.date);
    if (index != -1) {
      workouts[index] = workout;
      await _box.put('workouts', workouts.map((w) => w.toJson()).toList());
    }
  }

  @override
  Future<void> delete(String id) async {
    final workouts = await getAll();
    workouts.removeWhere((w) => w.date.toIso8601String() == id);
    await _box.put('workouts', workouts.map((w) => w.toJson()).toList());
  }
}
