import 'package:fitness_app/screens/exercises_screen.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';
import 'package:fitness_app/utils/video_extensions.dart';
import 'package:fitness_app/utils/video_extensions.dart';
import 'package:fitness_app/widgets/media_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/exercies_model.dart';
import '../services/exercises_service.dart';

import '../models/exercies_model.dart';
import '../services/exercises_service.dart';

class PhysicalTrainingScreen extends StatefulWidget {
  const PhysicalTrainingScreen({Key? key}) : super(key: key);

  @override
  State<PhysicalTrainingScreen> createState() => _PhysicalTrainingScreenState();
}

class _PhysicalTrainingScreenState extends State<PhysicalTrainingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ExercisesService _exercisesService = ExercisesService();
  List<Exercise> _exercises = [];
  bool _isLoading = true;
  String? _error;

  // Pagination
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isFetchingMore = false;
  final int _perPage = 1000; // load many to include subcategory 51

  final ScrollController _scrollController = ScrollController();

  // Example data - replace with your actual data

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadExercises(reset: true); // <-- Fix: load exercises on init
    _scrollController.addListener(_onScroll);
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore &&
        _currentPage < _lastPage &&
        !_isLoading) {
      _loadExercises();
    }
  }

  // Removed unused _getExercisesByCategory

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jismoniy tarbiya daqiqalari kompleksi'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _buildExerciseList('warmup', theme),
    );
  }

  Widget _buildExerciseList(String category, ThemeData theme) {
    // Show only 'Jismoniy tarbiya daqiqalari' subcategory (id: 51)
    List<Exercise> categoryExercises = _exercises
        .where((exercise) => exercise.categories.any((c) => c.id == 51))
        .toList();

    if (categoryExercises.isEmpty) {
      categoryExercises = _exercises
          .where((e) => e.name.toLowerCase().contains('jismoniy tarbiya'))
          .toList();
    }

    if (categoryExercises.isEmpty) {
      return Center(
        child: Text(
          "Jismoniy tarbiya daqiqalari topilmadi",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categoryExercises.reversed.toList().length,
      itemBuilder: (context, index) {
        final exercise = categoryExercises[index];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutInfoScreen(exercise: exercise),
                ));
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                exercise.media.length > 1
                    ? SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: exercise.media.length,
                          itemBuilder: (context, indexx) {
                            return MediaWidget(
                              width: MediaQuery.of(context).size.width -
                                  64, // Card margin va padding hisobga olinadi

                              url: exercise.media[indexx].originalUrl,
                              height: 250,
                            );
                          },
                        ),
                      )
                    : Center(
                        child: MediaWidget(
                          url: exercise.media.first.originalUrl,
                          height: 250,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        exercise.description,
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 12),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoChip(
                              icon: Icons.timer,
                              label:
                                  '${_roundToDurationBucket((double.parse(exercise.duration) * 60).round())} soniya',
                              theme: theme,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              icon: Icons.repeat,
                              label:
                                  "${exercise.count - 2} ~ ${exercise.count}",
                              theme: theme,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  int _toMinutes(String duration) {
    final value = double.tryParse(duration) ?? 0;
    if (value <= 0) return 0;
    return value > 60 ? (value / 60).round() : value.round();
  }

// ... existing code ...
  Widget _buildMediaWidget(String url, ThemeData theme,
      {double? height, double? width}) {
    final ext = url.split('.').last.toLowerCase();

    if (ext == 'json') {
      return Lottie.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: theme.colorScheme.surfaceVariant,
            child: Icon(
              Icons.fitness_center,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          );
        },
      );
    } else if (['mp4', 'mov', 'webm', 'mkv'].contains(ext)) {
      return url.toVideoPlayerWidget(
        aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
      );
    } else {
      return Image.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            color: theme.colorScheme.surfaceVariant,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yuklanmoqda...',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: theme.colorScheme.surfaceVariant,
            child: Icon(
              Icons.fitness_center,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          );
        },
      );
    }
  }

// ... existing code ...
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
