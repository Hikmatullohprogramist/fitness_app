import 'package:fitness_app/models/exercies_model.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/exercises_service.dart';
import 'package:lottie/lottie.dart';

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

  // Pagination
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isFetchingMore = false;
  final int _perPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadExercises(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      itemCount: categoryExercises.length +
          (_isFetchingMore && _currentPage <= _lastPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == categoryExercises.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
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
                        child: _buildMediaWidget(
                            exercise.media[0].originalUrl, theme,
                            height: 300, width: double.infinity),
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
                                height: 100, width: 100),
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
}
