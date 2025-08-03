import 'package:fitness_app/models/day_subcategory.dart';
import 'package:fitness_app/models/exercies_model.dart';
import 'package:fitness_app/models/level_day_response.dart';
import 'package:fitness_app/services/leve_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/exercises_service.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final ExercisesService _exercisesService = ExercisesService();
  final LevelService _levelService = LevelService();
  bool _isLoading = true;
  String? _error;

  final List<Map<String, dynamic>> weekDays = const [
    {
      'name': 'Dushanba',
      'date': '15',
      'month': 'Aprel',
      'icon': Icons.calendar_today,
      'totalTime': '8 daqiqa',
      'optimalTime': 25,
      'category': 'Bo\'yin va yelka',
      'categoryIcon': Icons.fitness_center,
      'workouts': [
        {
          'title': 'Bo\'yni mashq qilish',
          'duration': '3 daqiqa',
          'calories': '15 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': '07:00 - Ertalab',
          'category': 'Bo\'yin',
        },
        {
          'title': 'Yelka mashqlari',
          'duration': '5 daqiqa',
          'calories': '25 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': '18:00 - Kechqurun',
          'category': 'Yelka',
        },
      ],
    },
    {
      'name': 'Seshanba',
      'date': '16',
      'month': 'Aprel',
      'icon': Icons.calendar_today,
      'totalTime': '0 daqiqa',
      'optimalTime': 25,
      'category': 'Yoga',
      'categoryIcon': Icons.self_improvement,
      'workouts': [
        {
          'title': 'Yoga',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': '08:00 - Ertalab',
          'category': 'Yoga',
        },
      ],
    },
    {
      'name': 'Chorshanba',
      'date': '17',
      'month': 'Aprel',
      'icon': Icons.calendar_today,
      'totalTime': '0 daqiqa',
      'optimalTime': 25,
      'category': 'Kuch mashqlari',
      'categoryIcon': Icons.fitness_center,
      'workouts': [
        {
          'title': 'Kuch mashqlari',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Murakkab',
          'image': 'assets/workout.jpg',
          'time': '17:00 - Kechqurun',
          'category': 'Kuch',
        },
      ],
    },
    {
      'name': 'Payshanba',
      'date': '18',
      'month': 'Aprel',
      'icon': Icons.calendar_today,
      'totalTime': '0 daqiqa',
      'optimalTime': 25,
      'category': 'Stretching',
      'categoryIcon': Icons.accessibility_new,
      'workouts': [
        {
          'title': 'Stretching',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': '07:30 - Ertalab',
          'category': 'Stretching',
        },
      ],
    },
    {
      'name': 'Juma',
      'date': '19',
      'month': 'Aprel',
      'icon': Icons.calendar_today,
      'totalTime': '0 daqiqa',
      'optimalTime': 25,
      'category': 'Kardio',
      'categoryIcon': Icons.directions_run,
      'workouts': [
        {
          'title': 'Kardio',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'O\'rta',
          'image': 'assets/workout.jpg',
          'time': '18:30 - Kechqurun',
          'category': 'Kardio',
        },
      ],
    },
    {
      'name': 'Shanba',
      'date': '20',
      'month': 'Aprel',
      'icon': Icons.calendar_today,
      'totalTime': '0 daqiqa',
      'optimalTime': 25,
      'category': 'Kuch mashqlari',
      'categoryIcon': Icons.fitness_center,
      'workouts': [
        {
          'title': 'Kuch mashqlari',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Murakkab',
          'image': 'assets/workout.jpg',
          'time': '09:00 - Ertalab',
          'category': 'Kuch',
        },
      ],
    },
    {
      'name': 'Yakshanba',
      'date': '21',
      'month': 'Aprel',
      'icon': Icons.calendar_today,
      'totalTime': '0 daqiqa',
      'optimalTime': 0,
      'category': 'Dam olish',
      'categoryIcon': Icons.beach_access,
      'workouts': [
        {
          'title': 'Dam olish',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': 'Dam olish kuni',
          'category': 'Dam olish',
        },
      ],
    },
  ];

  final List<String> months = [
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

  int _selectedDayIndex = 0;
  String? _selectedMonth;
  String? _selectedMinute;
  String? _selectedLevel;

  final List<Map<String, dynamic>> levels = [
    {"id": 2, 'label': 'Minimal', 'minutes': 210},
    {"id": 4, 'label': 'Optimal', 'minutes': 245},
    {"id": 6, 'label': 'Maximal', 'minutes': 280},
  ];

  List<LevelDay>? _levelDays;
  bool _isLoadingLevelDays = false;
  String? _apiError;
  int? _selectedLevelId;

  List<SubCategoryWithCategory>? _subCategories;
  bool _isLoadingSubCategories = false;

  List<Exercise>? _exercises;
  bool _isLoadingExercises = false;

  // Step counter variables
  int _currentSteps = 0;
  int _dailyGoal = 10000;
  bool _isStepCounterActive = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _exercisesService.getExercises();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  double _getProgress(int currentTime, int optimalTime) {
    if (optimalTime == 0) return 0;
    return (currentTime / optimalTime).clamp(0.0, 1.0);
  }

  String _getProgressText(int currentTime, int optimalTime) {
    if (optimalTime == 0) return 'Dam olish kuni';
    return '$currentTime/$optimalTime daqiqa';
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) return Colors.green;
    if (progress >= 0.7) return Colors.orange;
    return Colors.red;
  }

  // Step counter methods
  void _startStepCounter() {
    // Simulate step counting - in a real app, this would use device sensors
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isStepCounterActive) {
        setState(() {
          _currentSteps += 10; // Simulate 10 steps every 2 seconds
        });
        _startStepCounter(); // Continue counting
      }
    });
  }

  void _stopStepCounter() {
    // Stop the step counter
    setState(() {
      _isStepCounterActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedMonth == null
            ? 'Oylar'
            : _selectedLevel == null
                ? _selectedMonth!
                : '$_selectedMonth - $_selectedLevel'),
        centerTitle: true,
        leading: _selectedMonth != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    if (_selectedLevel != null) {
                      _selectedLevel = null;
                    } else {
                      _selectedMonth = null;
                      _selectedDayIndex = 0;
                    }
                  });
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExercises,
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Xatolik yuz berdi',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadExercises,
                        child: const Text('Qayta urinish'),
                      ),
                    ],
                  ),
                )
              : _selectedMonth == null
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : _selectedLevel == null
                      ? _buildLevelSelection(context)
                      : _buildWeeklyWorkouts(
                          context,
                          _selectedMinute.toString(),
                        ),
    );
  }

  Widget _buildLevelSelection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Jismoniy tayyorgarlik darajasini tanlang',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...levels.map((level) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      _selectedLevel = level['label'];
                      _selectedLevelId = level['id'];
                      _isLoadingLevelDays = true;
                      _apiError = null;
                      _levelDays = null;
                      _selectedDayIndex = 0;
                      _subCategories = null;
                      _exercises = null;
                    });
                    try {
                      final resp =
                          await _levelService.getLevelDays(_selectedLevelId!);
                      setState(() {
                        _levelDays = resp.data.days;
                        _isLoadingLevelDays = false;
                        // Automatically select the first day if available
                        if (resp.data.days.isNotEmpty) {
                          _selectedDayIndex = 0;
                        }
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
                            level['label'] == 'Minimal'
                                ? Icons.looks_one
                                : level['label'] == 'Optimal'
                                    ? Icons.looks_two
                                    : Icons.looks_3,
                            color: Theme.of(context).secondaryHeaderColor,
                            size: 32,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level['label'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${level['minutes']} daqiqa/hafta',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
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

  Widget _buildWeeklyWorkouts(BuildContext context, String minut) {
    if (_isLoadingLevelDays) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_apiError != null) {
      return Center(child: Text(_apiError!));
    }
    if (_levelDays != null && _levelDays!.isNotEmpty) {
      final selectedLevelMap = levels.firstWhere(
          (l) => l['label'] == _selectedLevel,
          orElse: () => levels[0]);
      final int reglamentMinutes = selectedLevelMap['minutes'];

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
                            final resp = await _levelService
                                .getDaySubCategories(day.id, _selectedLevelId!);
                            setState(() {
                              _subCategories = resp.data.subCategories;
                              _isLoadingSubCategories = false;
                            });
                          } catch (e) {
                            setState(() {
                              _isLoadingSubCategories = false;
                            });
                            if (mounted) {
                              print(e);
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
                                "${(int.parse(day.duration) / _levelDays!.length).round()} daq",
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
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bugungi progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getProgressColor(
                          _getProgress(
                            int.tryParse(
                                    _levelDays![_selectedDayIndex].duration) ??
                                0,
                            reglamentMinutes,
                          ),
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getProgressText(
                          int.tryParse(
                                  _levelDays![_selectedDayIndex].duration) ??
                              0,
                          reglamentMinutes,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getProgressColor(
                            _getProgress(
                              int.tryParse(_levelDays![_selectedDayIndex]
                                      .duration) ??
                                  0,
                              reglamentMinutes,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _getProgress(
                      int.tryParse(_levelDays![_selectedDayIndex].duration) ??
                          0,
                      reglamentMinutes,
                    ),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(
                        _getProgress(
                          int.tryParse(
                                  _levelDays![_selectedDayIndex].duration) ??
                              0,
                          reglamentMinutes,
                        ),
                      ),
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        color: Theme.of(context).primaryColor, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Vaqt reglamenti: $reglamentMinutes daqiqa',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoadingSubCategories)
            const Expanded(child: Center(child: CircularProgressIndicator())),
          // Step Counter Widget
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.directions_walk,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kunlik qadamlar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isStepCounterActive,
                      onChanged: (value) {
                        setState(() {
                          _isStepCounterActive = value;
                          if (value) {
                            _startStepCounter();
                          } else {
                            _stopStepCounter();
                          }
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_currentSteps',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'qadam',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$_dailyGoal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'maqsad',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _currentSteps / _dailyGoal,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${((_currentSteps / _dailyGoal) * 100).round()}% bajarildi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoadingExercises)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Mashqlar yuklanmoqda...'),
                  ],
                ),
              ),
            ),
          if (_exercises != null)
            Expanded(
              child: _exercises!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fitness_center,
                              size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            "Mashqlar topilmadi",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Back button and title
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () async {
                                  setState(() {
                                    _exercises = null;
                                    _isLoadingSubCategories = true;
                                  });
                                  // Reload subcategories
                                  try {
                                    final resp =
                                        await _levelService.getDaySubCategories(
                                            _levelDays![_selectedDayIndex].id,
                                            _selectedLevelId!);
                                    setState(() {
                                      _subCategories = resp.data.subCategories;
                                      _isLoadingSubCategories = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      _isLoadingSubCategories = false;
                                    });
                                  }
                                },
                              ),
                              const Text(
                                "Subkategoriya mashqlari",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        // Exercises list
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _exercises!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final exercise = _exercises![index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to exercise details if needed
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${(double.parse(exercise.duration) * 60).round()} soniya',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
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
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          if (_subCategories != null && _exercises == null)
            Expanded(
              child: _subCategories!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            "Subkategoriya topilmadi",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _subCategories!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final sub = _subCategories![index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 18),
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
                                  Icon(Icons.category,
                                      size: 16, color: Colors.grey[600]),
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
                                          Icon(Icons.timer,
                                              size: 14,
                                              color: Colors.green[700]),
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
                              setState(() {
                                _isLoadingExercises = true;
                                // Don't hide subcategories immediately
                              });
                              try {
                                final resp =
                                    await _levelService.getSubCategoryExercises(
                                  sub.id,
                                  _selectedLevelId!,
                                  _levelDays![_selectedDayIndex].id,
                                );

                                setState(() {
                                  _exercises = resp.data.exercises;
                                  _subCategories =
                                      null; // Hide subcategories when exercises are loaded
                                  _isLoadingExercises = false;
                                });
                              } catch (e) {
                                // Reload subcategories on error
                                try {
                                  final resp =
                                      await _levelService.getDaySubCategories(
                                          _levelDays![_selectedDayIndex].id,
                                          _selectedLevelId!);
                                  setState(() {
                                    _subCategories = resp.data.subCategories;
                                    _isLoadingExercises = false;
                                  });
                                } catch (subError) {
                                  setState(() {
                                    _isLoadingExercises = false;
                                  });
                                }
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Mashqlarni yuklashda xatolik: $e")),
                                  );
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          if (_isLoadingExercises)
            const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      );
    }
    final filteredWeeks =
        weekDays.where((w) => w['month'] == _selectedMonth).toList();
    if (filteredWeeks.isEmpty) {
      return const Center(child: Text('Bu oyda mashqlar topilmadi'));
    }
    final selectedLevelMap = levels.firstWhere(
        (l) => l['label'] == _selectedLevel,
        orElse: () => levels[0]);
    final int reglamentMinutes = selectedLevelMap['minutes'];
    return Column(
      children: [
        // Weekday selector
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
            itemCount: filteredWeeks.length,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final isSelected = index == _selectedDayIndex;
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
                      onTap: () {
                        setState(() {
                          _selectedDayIndex = index;
                        });
                      },
                      child: SizedBox(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              filteredWeeks[index]['name'],
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
                              "${(int.parse(minut) / 7).round()} daq",
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
        // Progress card + reglament
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bugungi progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getProgressColor(
                        _getProgress(
                          int.parse(filteredWeeks[_selectedDayIndex]
                                  ['totalTime']
                              .toString()
                              .split(' ')[0]),
                          filteredWeeks[_selectedDayIndex]['optimalTime'],
                        ),
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getProgressText(
                        int.parse(filteredWeeks[_selectedDayIndex]['totalTime']
                            .toString()
                            .split(' ')[0]),
                        filteredWeeks[_selectedDayIndex]['optimalTime'],
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getProgressColor(
                          _getProgress(
                            int.parse(filteredWeeks[_selectedDayIndex]
                                    ['totalTime']
                                .toString()
                                .split(' ')[0]),
                            filteredWeeks[_selectedDayIndex]['optimalTime'],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _getProgress(
                    int.parse(filteredWeeks[_selectedDayIndex]['totalTime']
                        .toString()
                        .split(' ')[0]),
                    filteredWeeks[_selectedDayIndex]['optimalTime'],
                  ),
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(
                      _getProgress(
                        int.parse(filteredWeeks[_selectedDayIndex]['totalTime']
                            .toString()
                            .split(' ')[0]),
                        filteredWeeks[_selectedDayIndex]['optimalTime'],
                      ),
                    ),
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time,
                      color: Theme.of(context).primaryColor, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Vaqt reglamenti: $reglamentMinutes daqiqa',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Workouts list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount:
                (filteredWeeks[_selectedDayIndex]['workouts'] as List).length,
            itemBuilder: (context, index) {
              final workout =
                  filteredWeeks[_selectedDayIndex]['workouts'][index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Workout image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.asset(
                            workout['image'],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Category badge
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  filteredWeeks[_selectedDayIndex]
                                      ['categoryIcon'],
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  workout['category'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Time badge
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              workout['time'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Difficulty badge
                        Positioned(
                          top: 50,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              workout['difficulty'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Workout info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                workout['duration'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 24),
                              Icon(Icons.local_fire_department_outlined,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                workout['calories'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
