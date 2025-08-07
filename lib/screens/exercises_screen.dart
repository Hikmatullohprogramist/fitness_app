import 'package:fitness_app/models/exercies_model.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/exercises_service.dart';
import 'package:lottie/lottie.dart';
import '../utils/video_extensions.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({Key? key}) : super(key: key);

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ExercisesService _exercisesService = ExercisesService();
  List<Exercise> _exercises = [];
  bool _isLoading = true;
  String? _error;

  // Removed pagination variables since we load all exercises at once

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadExercises(reset: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Removed _onScroll method since we load all exercises at once

  Future<void> _loadExercises({bool reset = false}) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _exercises = [];
      });

      // Load all exercises at once to avoid pagination issues
      final response = await _exercisesService.getExercises(
          page: 1, perPage: 1000); // Load 1000 exercises at once
      final List<Exercise> newExercises =
          List<Exercise>.from(response['exercises']);

      setState(() {
        _exercises = newExercises; // Replace instead of addAll
        _isLoading = false;
      });

      print("Loaded ${newExercises.length} exercises");
      if (newExercises.isNotEmpty) {
        print(
            "First exercise categories: ${newExercises.first.categories.map((c) => '${c.id}:${c.name}').toList()}");
      }

      // Test individual exercises
      _testIndividualExercises();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Exercise> _getExercisesByCategory(String category) {
    print("Filtering for category: $category");
    print("Total exercises loaded: ${_exercises.length}");

    return _exercises.where((exercise) {
      final categoryIds = exercise.categories.map((c) {
        return c.id;
      }).toList();

      print("Exercise: ${exercise.name}, Category IDs: $categoryIds");

      switch (category) {
        case 'individual':
          final hasIndividual = categoryIds.contains(1);
          print("Individual check for ${exercise.name}: $hasIndividual");
          return hasIndividual;
        case 'partner':
          return categoryIds.contains(2);
        case 'team':
          return categoryIds.contains(3);
        default:
          print("Unknown category: $category");
          return false;
      }
    }).toList();
  }

  // Test method to debug individual exercises
  void _testIndividualExercises() {
    print("=== TESTING INDIVIDUAL EXERCISES ===");
    print("Total exercises: ${_exercises.length}");

    final individualExercises = _exercises.where((exercise) {
      final categoryIds = exercise.categories.map((c) => c.id).toList();
      return categoryIds.contains(1);
    }).toList();

    print("Individual exercises found: ${individualExercises.length}");
    for (var exercise in individualExercises) {
      print(
          "Individual exercise: ${exercise.name}, Categories: ${exercise.categories.map((c) => '${c.id}:${c.name}').toList()}");
    }
    print("=== END TEST ===");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mashqlar'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _testIndividualExercises,
            tooltip: 'Debug Individual Exercises',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.person),
              text: 'Individual',
            ),
            Tab(
              icon: Icon(Icons.people),
              text: 'Juftlikda',
            ),
            Tab(
              icon: Icon(Icons.groups),
              text: 'Jamoaviy',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildExerciseList('individual', theme),
                    _buildExerciseList('partner', theme),
                    _buildExerciseList('team', theme),
                  ],
                ),
    );
  }

  Widget _buildExerciseList(String category, ThemeData theme) {
    final categoryExercises = _getExercisesByCategory(category);

    if (_isLoading && _exercises.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (categoryExercises.isEmpty) {
      return Center(
        child: Text(
          'Bu kategoriyada mashqlar topilmadi',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
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
          child: InkWell(
            onTap: () {
              print("navigat");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutInfoScreen(exercise: exercise),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (exercise.media.isNotEmpty)
                  Container(
                    height: 400,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
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
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              exercise.categories.any((c) => c.id == 1)
                                  ? exercise.name
                                  : exercise.categories.isNotEmpty
                                      ? exercise.categories.first.name
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
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(double.parse(exercise.duration) * 60).round()} soniya',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
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
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
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

  Widget _buildMediaWidget(String url, ThemeData theme,
      {double? height, double? width}) {
    final ext = url.split('.').last.toLowerCase();

    // Wrap all widgets in a Container with proper constraints
    Widget buildWidget() {
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
        return Container(
          height: height,
          width: width,
          child: url.toVideoPlayerWidget(
            aspectRatio: 16 / 9,
            autoPlay: false,
            looping: false,
          ),
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

    return Container(
      height: height,
      width: width,
      child: buildWidget(),
    );
  }
}
