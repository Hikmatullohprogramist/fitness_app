import 'package:flutter/material.dart';

import '../models/level_model.dart';
import '../models/level_day_response.dart';
import '../models/day_subcategory.dart' as DaySub;
import '../models/exercies_model.dart';
import '../services/leve_service.dart';
import 'subcategory_exercises_screen.dart';

class PhysicalDevelopmentLevelScreen extends StatefulWidget {
  const PhysicalDevelopmentLevelScreen({super.key});

  @override
  State<PhysicalDevelopmentLevelScreen> createState() =>
      _PhysicalDevelopmentLevelScreenState();
}

class _PhysicalDevelopmentLevelScreenState
    extends State<PhysicalDevelopmentLevelScreen> {
  final LevelService _levelService = LevelService();

  bool _isLoading = true;
  String? _error;

  LevelResponse? levelResponse;
  List<Level> get _levels => levelResponse?.data.levels ?? [];

  // Selection state
  String? _selectedLevel;
  int? _selectedLevelId;
  String? _selectedMonth;
  int _selectedDayIndex = 0;

  // Days/Subcategories/Exercises
  List<LevelDay>? _levelDays;
  bool _isLoadingLevelDays = false;
  String? _apiError;

  List<DaySub.SubCategoryWithCategory>? _subCategories;
  bool _isLoadingSubCategories = false;

  List<Exercise>? _exercises;
  // Note: exercises loading handled via list being null/non-null; keep simple

  final List<String> months = const [
    'Yanvar',
    'Fevral',
    'Mart',
    'Aprel',
    'May',
    'Iyun',
    'Iyul',
    'Avgust',
    'Sentyabr',
    'Oktyabr',
    'Noyabr',
    'Dekabr'
  ];

  @override
  void initState() {
    super.initState();
    _fetchLevels();
  }

  Future<void> _fetchLevels() async {
    try {
      final response = await _levelService.getLevels();
      setState(() {
        levelResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  IconData _getLevelIcon(String levelName) {
    if (_levels.isEmpty) return Icons.self_improvement;
    final level = _levels.firstWhere(
      (l) => l.name == levelName,
      orElse: () => _levels[0],
    );
    return level.timeRegulation == 'maximal'
        ? Icons.directions_run
        : level.timeRegulation == 'high'
            ? Icons.fitness_center
            : level.timeRegulation == 'medium'
                ? Icons.accessibility_new
                : Icons.self_improvement;
  }

  String _getLevelDescription(String levelName) {
    if (_levels.isEmpty) return '';
    final level = _levels.firstWhere(
      (l) => l.name == levelName,
      orElse: () => _levels[0],
    );
    return level.name == "maximal"
        ? "Eng yuqori darajadagi jismoniy tayyorgarlik"
        : level.name == "high"
            ? "Yuqori darajadagi jismoniy tayyorgarlik"
            : level.name == "medium"
                ? "O'rtacha darajadagi jismoniy tayyorgarlik"
                : "Boshlang'ich darajadagi jismoniy tayyorgarlik";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedLevel == null
              ? 'Darajalar'
              : _selectedMonth == null
                  ? _selectedLevel!
                  : '$_selectedLevel - $_selectedMonth',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: _selectedLevel != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    if (_selectedMonth != null) {
                      _selectedMonth = null;
                      _selectedDayIndex = 0;
                    } else if (_selectedLevel != null) {
                      _selectedLevel = null;
                      _selectedLevelId = null;
                      _levelDays = null;
                      _subCategories = null;
                      _exercises = null;
                    }
                  });
                },
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _error != null
              ? Center(child: Text(_error!))
              : _selectedLevel == null
                  ? _buildLevelSelection(context)
                  : _selectedMonth == null
                      ? _buildMonthSelection(context)
                      : _buildWeeklyWorkouts(context),
    );
  }

  Widget _buildLevelSelection(BuildContext context) {
    if (_levels.isEmpty) {
      return const Center(child: Text('Darajalar topilmadi'));
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jismoniy tayyorgarlik darajasini tanlang',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._levels.map((level) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      _selectedLevel = level.name;
                      _selectedLevelId = level.id;
                      _isLoadingLevelDays = true;
                      _apiError = null;
                      _levelDays = null;
                      _selectedMonth = null;
                      _selectedDayIndex = 0;
                      _subCategories = null;
                      _exercises = null;
                    });
                    try {
                      final resp = await _levelService.getLevelDays(level.id);
                      setState(() {
                        _levelDays = resp.data.days;
                        _isLoadingLevelDays = false;
                      });
                    } catch (e) {
                      setState(() {
                        _apiError = e.toString();
                        _isLoadingLevelDays = false;
                      });
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 6,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 22, horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            _getLevelIcon(level.name),
                            color: Theme.of(context).secondaryHeaderColor,
                            size: 32,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getLevelDescription(level.name),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[200],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMonthSelection(BuildContext context) {
    if (_isLoadingLevelDays) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_apiError != null) {
      return Center(child: Text(_apiError!));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
        ),
        itemCount: months.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonth = months[index];
                _selectedDayIndex = 0;
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                  months[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyWorkouts(BuildContext context) {
    if (_levelDays == null || _levelDays!.isEmpty) {
      return const Center(child: Text('Kunlar topilmadi'));
    }

    return Column(
      children: [
        Container(
          height: 110,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _levelDays!.length,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedDayIndex;
              final day = _levelDays![index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Material(
                    elevation: isSelected ? 4 : 0,
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[100],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        setState(() {
                          _selectedDayIndex = index;
                          _isLoadingSubCategories = true;
                          _subCategories = null;
                          _exercises = null;
                        });

                        try {
                          final resp = await _levelService.getDaySubCategories(
                              day.id, _selectedLevelId!);
                          setState(() {
                            _subCategories = resp.data.subCategories;
                            _isLoadingSubCategories = false;
                          });
                        } catch (e) {
                          setState(() {
                            _isLoadingSubCategories = false;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Subkategoriyalarni yuklashda xatolik: $e'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                      child: SizedBox(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              day.name,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            Text(
                              "${day.duration} daq",
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoadingSubCategories)
          const Expanded(child: Center(child: CircularProgressIndicator())),
        if (_exercises != null)
          Expanded(child: _buildExercisesList(context))
        else if (_subCategories != null)
          Expanded(child: _buildSubCategoriesList(context))
      ],
    );
  }

  Widget _buildSubCategoriesList(BuildContext context) {
    if (_subCategories == null || _subCategories!.isEmpty) {
      return const Center(child: Text('Subkategoriya topilmadi'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _subCategories!.length,
      itemBuilder: (context, index) {
        final sub = _subCategories![index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white,
              ),
            ),
            title: Text(
              sub.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Theme.of(context).primaryColor,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    sub.category.name,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  if (sub.pivot.duration != null) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer, size: 14, color: Colors.green[700]),
                          const SizedBox(width: 3),
                          Text(
                            '${sub.pivot.duration ?? ""} daq',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.grey),
            onTap: () async {
              final dayId = _levelDays![_selectedDayIndex].id;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoryExercisesScreen(
                    subCategoryId: sub.id,
                    levelId: _selectedLevelId!,
                    dayId: dayId,
                    title: sub.name,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildExercisesList(BuildContext context) {
    if (_exercises == null || _exercises!.isEmpty) {
      return const Center(child: Text('Mashqlar topilmadi'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _exercises!.length,
      itemBuilder: (context, index) {
        final exercise = _exercises![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${(double.parse(exercise.duration) * 60).round()} soniya',
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
