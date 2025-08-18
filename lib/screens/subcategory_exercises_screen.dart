import 'package:fitness_app/services/exercises_service.dart';
import 'package:fitness_app/widgets/media_widget.dart';
import 'package:flutter/material.dart';

import 'package:fitness_app/models/exercies_model.dart';
import 'package:fitness_app/services/leve_service.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';

class SubCategoryExercisesScreen extends StatefulWidget {
  final int subCategoryId;
  final int levelId;
  final int dayId;
  final String title;

  const SubCategoryExercisesScreen({
    super.key,
    required this.subCategoryId,
    required this.levelId,
    required this.dayId,
    required this.title,
  });

  @override
  State<SubCategoryExercisesScreen> createState() =>
      _SubCategoryExercisesScreenState();
}

class _SubCategoryExercisesScreenState
    extends State<SubCategoryExercisesScreen> {
  final LevelService _levelService = LevelService();
  final ExercisesService _exercisesService = ExercisesService();

  bool _isLoading = true;
  String? _error;
  List<Exercise> _exercises = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isFetchingMore = false;
  final int _perPage = 1000; // load many to include subcategory 51

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      if (widget.subCategoryId == 49) {
        await _loadExercises();
        List<Exercise> categoryExercises = _exercises
            .where((exercise) => exercise.categories.any((c) => c.id == 51))
            .toList();
      } else {
        final resp = await _levelService.getSubCategoryExercises(
          widget.subCategoryId,
          widget.levelId,
          widget.dayId,
        );
        setState(() {
          _exercises = resp.data.exercises;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadExercises({bool reset = false}) async {
    try {
      if (reset) {
        setState(() {
          _isLoading = true;
          _error = null;
          _currentPage = 1;
          _lastPage = 1;
          _exercises = [];
        });
      } else {
        setState(() {
          _isFetchingMore = true;
        });
      }
      final response = await _exercisesService.getExercises(
          page: _currentPage, perPage: _perPage);
      final List<Exercise> newExercises =
          List<Exercise>.from(response['exercises']);
      setState(() {
        _exercises.addAll(newExercises);
        _currentPage = response['currentPage'] + 1;
        _lastPage = response['lastPage'];
        _isLoading = false;
        _isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _fetchExercises,
                        child: const Text('Qayta urinish'),
                      ),
                    ],
                  ),
                )
              : _exercises.isEmpty
                  ? const Center(child: Text('Mashqlar topilmadi'))
                  : buildExercies(),
    );
  }

  Widget buildExercies() {
    List<Exercise> categoryExercises = _exercises
        .where((exercise) => exercise.categories.any((c) => c.id == 51))
        .toList();

    if (categoryExercises.isEmpty) {
      categoryExercises = _exercises
          .where((e) => e.name.toLowerCase().contains('jismoniy tarbiya'))
          .toList();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.subCategoryId == 49
          ? categoryExercises.length
          : _exercises.length,
      itemBuilder: (context, index) {
        final exercise = widget.subCategoryId == 49
            ? categoryExercises[index]
            : _exercises[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutInfoScreen(exercise: exercise),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exercise.media.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: MediaWidget(
                        url: exercise.media[0].originalUrl,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          exercise.name.contains("Jismoniy tarbiya daqiqalari")
                              ? "Chigalyozdi mashqlari"
                              : exercise.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: exercise.name.contains("Yengil yugurish") ||
                                exercise.name.contains("Tez sur'atda yurish")
                            ? Container()
                            : Text(
                                '${_roundToDurationBucket((double.parse(exercise.duration) * 60).round())} soniya',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise.description,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int _roundToDurationBucket(int seconds) {
    if (seconds >= 40 && seconds < 45) return 40;
    if (seconds >= 45 && seconds < 50) return 45;
    if (seconds >= 50 && seconds < 55) return 50;
    if (seconds >= 55 && seconds <= 60) return 60;
    return seconds;
  }
}
