import '../models/evaluation.dart';
import '../repositories/evaluation_repository.dart';

class EvaluationService {
  final EvaluationRepository _repository;

  EvaluationService(this._repository);

  Future<void> saveEvaluation(Evaluation evaluation) async {
    await _repository.save(evaluation);
  }

  Future<List<Evaluation>> getAllEvaluations() async {
    return await _repository.getAll();
  }

  Future<Evaluation?> getEvaluationByDate(DateTime date) async {
    return await _repository.get(date.toIso8601String());
  }

  Future<void> updateEvaluation(Evaluation evaluation) async {
    await _repository.update(evaluation);
  }

  Future<void> deleteEvaluation(DateTime date) async {
    await _repository.delete(date.toIso8601String());
  }

  double calculateOverallScore(Map<String, int> answers) {
    if (answers.isEmpty) return 0.0;

    final totalScore = answers.values.reduce((a, b) => a + b);
    return totalScore / answers.length;
  }

  String getEvaluationFeedback(double score) {
    if (score >= 4.5) {
      return 'Ajoyib! Siz juda yaxshi natijalarga erishdingiz.';
    } else if (score >= 3.5) {
      return 'Yaxshi! Siz yaxshi natijalarga erishdingiz.';
    } else if (score >= 2.5) {
      return 'O\'rtacha. Yaxshiroq natijalarga erishish uchun qo\'shimcha harakat qiling.';
    } else {
      return 'Sizga yordam kerak. Murabbiyingiz bilan bog\'laning.';
    }
  }
}
