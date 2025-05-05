import 'package:hive/hive.dart';
import '../models/evaluation.dart';
import 'base_repository.dart';

class EvaluationRepository implements BaseRepository<Evaluation> {
  final Box<List> _box;

  EvaluationRepository(this._box);

  @override
  Future<void> save(Evaluation evaluation) async {
    final evaluations = await getAll();
    evaluations.add(evaluation);
    await _box.put('evaluations', evaluations.map((e) => e.toJson()).toList());
  }

  @override
  Future<Evaluation?> get(String id) async {
    final evaluations = await getAll();
    return evaluations.firstWhere((e) => e.date.toIso8601String() == id);
  }

  @override
  Future<List<Evaluation>> getAll() async {
    final data = _box.get('evaluations');
    if (data == null) return [];
    return (data as List).map((e) => Evaluation.fromJson(e)).toList();
  }

  @override
  Future<void> update(Evaluation evaluation) async {
    final evaluations = await getAll();
    final index = evaluations.indexWhere((e) => e.date == evaluation.date);
    if (index != -1) {
      evaluations[index] = evaluation;
      await _box.put(
          'evaluations', evaluations.map((e) => e.toJson()).toList());
    }
  }

  @override
  Future<void> delete(String id) async {
    final evaluations = await getAll();
    evaluations.removeWhere((e) => e.date.toIso8601String() == id);
    await _box.put('evaluations', evaluations.map((e) => e.toJson()).toList());
  }
}
