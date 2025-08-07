import 'package:fitness_app/utils/video_extensions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
  final int _perPage = 10;

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

  List<Exercise> _getExercisesByCategory(String category) {
    print("category $category");
    return _exercises.where((exercise) {
      final categoryIds = exercise.categories.map((c) {
        print(c.name);
        return c.id;
      }).toList();
      switch (category) {
        case 'individual':
          return categoryIds.contains(1);
        case 'partner':
          return categoryIds.contains(2);
        case 'team':
          return categoryIds.contains(3);
        default:
          return false;
      }
    }).toList();
  }

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
        title: const Text('Jismoniy tayyorgarlik kompleksi'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _buildExerciseList('warmup', theme),
    );
  }

  Widget _buildExerciseList(String category, ThemeData theme) {
    // Fix: Use a valid category or show all
    final categoryExercises =
        _getExercisesByCategory("individual"); // or use _exercises for all

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categoryExercises.length,
      itemBuilder: (context, index) {
        final exercise = categoryExercises[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (exercise.media.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: _buildMediaWidget(
                          exercise.media[0].originalUrl, theme,
                          height: 400, width: double.infinity),
                    ),
                    if (exercise.media.length > 1)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                          ),
                          child: _buildMediaWidget(
                              exercise.media[1].originalUrl, theme,
                              height: 300, width: 100),
                        ),
                      ),
                  ],
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
                      exercise.name,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoChip(
                            icon: Icons.timer,
                            label: exercise.duration.toString(),
                            theme: theme,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            icon: Icons.repeat,
                            label: exercise.vacationTime.toString(),
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
        );
      },
    );
  }

  Widget _buildMediaWidget(String url, ThemeData theme,
      {double? height, double? width}) {
    final ext = url.split('.').last.toLowerCase();
    if (ext == 'json') {
      return Lottie.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.cover,
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
