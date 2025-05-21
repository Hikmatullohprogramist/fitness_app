import 'package:fitness_app/models/exercies_model.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/exercises_service.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _exercisesService.getExercises();
      if (response.isNotEmpty) {
        setState(() {
          _exercises = List<Exercise>.from(response);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'No exercises found';
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Exercise> _getExercisesByCategory(String category) {
    return _exercises;

    // .where((exercise) {
    //   final categories = exercise.categories.map((category) => category.name);
    //   switch (category) {
    //     case 'individual':
    //       return categories.contains(1); // Yoga category
    //     case 'partner':
    //       return categories.contains(2); // Shoulder category
    //     case 'team':
    //       return categories.contains(3); // Abdominal category
    //     default:
    //       return false;
    //   }
    // }).toList();
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
        title: const Text('Mashqlar'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
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
                if (exercise.media != null && exercise.media.isNotEmpty)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.network(
                          exercise.media[0].originalUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: theme.colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.fitness_center,
                                size: 48,
                                color: theme.colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ),
                      if (exercise.media.length > 1)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              exercise.media[1].originalUrl,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100,
                                  width: 100,
                                  color: theme.colorScheme.surfaceVariant,
                                  child: Icon(
                                    Icons.fitness_center,
                                    size: 24,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
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
                              '${exercise.duration} daqiqa',
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
}
