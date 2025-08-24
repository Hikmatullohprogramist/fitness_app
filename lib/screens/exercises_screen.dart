import 'package:fitness_app/models/exercies_model.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';
import 'package:fitness_app/widgets/dam_olish_timer.dart';
import 'package:fitness_app/widgets/timer_widget.dart';
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

  String _roundToDurationBucket(int seconds) {
    if (seconds >= 40 && seconds < 45) return "40 soniya";
    if (seconds >= 45 && seconds < 50) return "45 soniya";
    if (seconds >= 50 && seconds < 55) return "50 soniya";

    // 55 dan 60 gacha -> 1 daqiqa
    if (seconds >= 55 && seconds <= 60) return "1 daqiqa";

    if (seconds > 60) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;

      if (remainingSeconds == 0) {
        return "$minutes daqiqa"; // ✅ faqat daqiqa yoziladi
      } else {
        return "$minutes daqiqa $remainingSeconds soniya";
      }
    }

    return "$seconds soniya";
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.bug_report),
        //     onPressed: _testIndividualExercises,
        //     tooltip: 'Debug Individual Exercises',
        //   ),
        // ],
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

    // Group by subcategory name (exclude only the current main category id)
    final int mainCategoryId = _mainCategoryIdForTab(category);
    final Map<String, List<Exercise>> subcategoryToExercises = {};
    for (final exercise in categoryExercises) {
      final subcategoryName = _getSubcategoryName(exercise, mainCategoryId);
      subcategoryToExercises.putIfAbsent(subcategoryName, () => []);
      subcategoryToExercises[subcategoryName]!.add(exercise);
    }

    // Custom order for "Individual" category
    final List<String> customOrder = [
      "Tez sur'atda yurish",
      "Yengil yugurish",
      "Arqonda sakrash",
      "Jismoniy tarbiya daqiqalari",
      "Qo'l va yelka muskullari uchun mashqlar",
      "Qorin muskullari uchun mashqlar",
      "Bel va orqa muskullari uchun mashqlar",
      "Butun tana muskullari uchun mashqlar",
      "Oyoq muskullari uchun mashqlar",
      "Aerobika mashqlari",
      "Kardio mashqlari",
      "Yuqori intensivlikdagi mashqlar",
      "Cho'zilish mashqlari",
      "Yoga mashqlari",
    ];

    // Sort subcategories
    List<String> sortedSubcategories;
    if (category == "individual") {
      sortedSubcategories = customOrder
          .where((sub) => subcategoryToExercises.keys.contains(sub))
          .toList();
    } else {
      sortedSubcategories = subcategoryToExercises.keys.toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    }

    final List<Widget> children = [];
    for (final subcat in sortedSubcategories) {
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            subcat,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      final exercisesInSubcat = subcategoryToExercises[subcat]!;

      for (final exercise in exercisesInSubcat) {
        children.add(
          Card(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exercise.media.isNotEmpty)
                    SizedBox(
                      height: 400,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: exercise.media.length > 1
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: exercise.media.length,
                                itemBuilder: (context, index) {
                                  return _buildMediaWidget(
                                    exercise.media[index].originalUrl,
                                    theme,
                                    height: 400,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                },
                              )
                            : _buildMediaWidget(
                                exercise.media[0].originalUrl,
                                theme,
                                height: 400,
                                width: double.infinity,
                              ),
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
                                exercise.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TimerWidget(exercise: exercise),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exercise.description,
                          style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 12),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        DamOlishTimer(exercise: exercise),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return ListView(
      controller: _scrollController,
      children: children,
    );
  }

  String _getSubcategoryName(Exercise exercise, int currentMainCategoryId) {
    // Exclude only the current tab's main category id and pick the first remaining as subcategory
    final sub = exercise.categories
        .where((c) => c.id != currentMainCategoryId)
        .toList();
    if (sub.isNotEmpty) {
      return sub.first.name.trim();
    }
    // Fallback: group by exercise name if no subcategory present in API
    return exercise.name.trim();
  }

  int _mainCategoryIdForTab(String categoryKey) {
    switch (categoryKey) {
      case 'individual':
        return 1;
      case 'partner':
        return 2;
      case 'team':
        return 3;
      default:
        return -1; // Unknown, don't exclude anything
    }
  }

  Widget _buildMediaWidget(String url, ThemeData theme,
      {double? height, double? width}) {
    final ext = url.split('.').last.toLowerCase();

    // Wrap all widgets in a Container with proper constraints
    Widget buildWidget() {
      if (ext == 'json') {
        return Container(
          height: height,
          width: width,
          color: theme.colorScheme.surfaceVariant,
          alignment: Alignment.center,
          child: Lottie.network(
            url,
            height: height,
            width: width,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.fitness_center,
                size: 48,
                color: theme.colorScheme.primary,
              );
            },
          ),
        );
      } else if (['mp4', 'mov', 'webm', 'mkv'].contains(ext)) {
        return Container(
          height: height,
          width: width,
          color: theme.colorScheme.surfaceVariant,
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: url.toVideoPlayerWidget(
              aspectRatio: 16 / 9,
              autoPlay: false,
              looping: false,
            ),
          ),
        );
      } else {
        return Container(
          height: height,
          width: width,
          color: theme.colorScheme.surfaceVariant,
          alignment: Alignment.center,
          child: Image.network(
            url,
            height: height,
            width: width,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.fitness_center,
                size: 48,
                color: theme.colorScheme.primary,
              );
            },
          ),
        );
      }
    }

    return SizedBox(
      height: height,
      width: width,
      child: buildWidget(),
    );
  }
}
