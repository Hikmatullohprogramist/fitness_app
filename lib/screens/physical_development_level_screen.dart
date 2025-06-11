import 'package:flutter/material.dart';

import '../models/level_model.dart';
import '../services/leve_service.dart';

class PhysicalDevelopmentLevelScreen extends StatefulWidget {
  const PhysicalDevelopmentLevelScreen({super.key});

  @override
  State<PhysicalDevelopmentLevelScreen> createState() =>
      _PhysicalDevelopmentLevelScreenState();
}

class _PhysicalDevelopmentLevelScreenState
    extends State<PhysicalDevelopmentLevelScreen> {
  String? _selectedLevel;
  String? _selectedDay;
  int? _selectedDayId;
  Map<String, dynamic>? _selectedSubCategory;

  // Available levels - you should fetch this from API


  //write getter level list from levelresponse
  List<Level> get _levels => levelResponse?.data.levels ?? [];

  LevelResponse? levelResponse;

  Future<void> _fetchLevels() async {
    try {
      final response = await LevelService().getLevels(); // Replace with your actual service method


      setState(() {
         levelResponse = response;



      });

    } catch (e) {
      // Handle exceptions
      print('Exception occurred while fetching levels: $e');
    }
  }
  // This should come from API call
  Map<String, dynamic>? _levelDaysData;

  // Sample data structure based on your API response
  final Map<String, dynamic> _sampleApiData = {
    "success": true,
    "message": "Level days retrieved successfully",
    "data": {
      "level": {
        "id": 6,
        "name": "Maximal",
        "time_regulation": "maximal",
        "time": "280"
      },
      "days": [
        {
          "id": 36,
          "level_id": 6,
          "name": "Dushanba",
          "duration": "40",
          "sub_categories": [
            {
              "id": 22,
              "name": "Arqonda sakrash",
            },
            {
              "id": 28,
              "name": "Yelka muskullari uchun mashqlar",
            },
            {
              "id": 33,
              "name": "Tez sur'atda yurish",
            },
          ]
        },
        // Add more days...
      ]
    }
  };

  Color _getLevelColor(String levelName) {
    final level =_levels.firstWhere(
      (l) => l.name == levelName,
      orElse: () => _levels[0],
    );
    return level.timeRegulation == 'maximal'
        ? Colors.red
        : level.timeRegulation == 'high'
            ? Colors.orange
            : level.timeRegulation == 'medium'
                ? Colors.yellow
                : Colors.green;
  }

  IconData _getLevelIcon(String levelName) {
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

  // Simulate API call - replace with actual API call
  Future<void> _fetchLevelDays(String levelName) async {
    // Here you would make an actual API call
    // For now, we'll use sample data
    setState(() {
      _levelDaysData = _sampleApiData['data'];
    });
  }

  void _selectLevel(String levelName) {
    setState(() {
      _selectedLevel = levelName;
      _selectedDay = null;
      _selectedDayId = null;
      _selectedSubCategory = null;
    });
    _fetchLevelDays(levelName);
  }

  void _selectDay(String dayName, int dayId) {
    setState(() {
      _selectedDay = dayName;
      _selectedDayId = dayId;
      _selectedSubCategory = null;
    });
  }

  void _selectSubCategory(Map<String, dynamic> subCategory) {
    setState(() {
      _selectedSubCategory = subCategory;
    });
  }

  void _goBack() {
    setState(() {
      if (_selectedSubCategory != null) {
        _selectedSubCategory = null;
      } else if (_selectedDay != null) {
        _selectedDay = null;
        _selectedDayId = null;
      } else if (_selectedLevel != null) {
        _selectedLevel = null;
        _levelDaysData = null;
      }
    });
  }

  List<Map<String, dynamic>> _getCurrentDaySubCategories() {
    if (_levelDaysData == null || _selectedDayId == null) return [];

    final days = _levelDaysData!['days'] as List;
    final selectedDay = days.firstWhere(
      (day) => day['id'] == _selectedDayId,
      orElse: () => null,
    );

    if (selectedDay == null) return [];
    return List<Map<String, dynamic>>.from(selectedDay['sub_categories'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: (_selectedLevel != null)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedLevel == null) ...[
                _buildLevelSelection(),
              ] else if (_selectedDay == null) ...[
                _buildDaySelection(),
              ] else if (_selectedSubCategory == null) ...[
                _buildSubCategorySelection(),
              ] else ...[
                _buildExerciseDetails(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    if (_selectedSubCategory != null) {
      return _selectedSubCategory!['name'];
    } else if (_selectedDay != null) {
      return '$_selectedDay mashqlari';
    } else if (_selectedLevel != null) {
      return '$_selectedLevel daraja kunlari';
    }
    return 'Jismoniy rivojlanganlik darajasi';
  }

  Widget _buildLevelSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O\'zingizning jismoniy rivojlanganlik darajangizni tanlang:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ..._levels.map((level) {
          final levelName = level.name;
          final isSelected = _selectedLevel == levelName;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () => _selectLevel(levelName),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getLevelColor(levelName)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? _getLevelColor(levelName)
                        : Colors.grey.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getLevelColor(levelName).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                       _getLevelIcon(levelName),
                        color: _getLevelColor(levelName),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            levelName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getLevelDescription(levelName),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getLevelColor(levelName).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              level.timeRegulation,
                              style: TextStyle(
                                color: _getLevelColor(levelName),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: _getLevelColor(levelName),
                        size: 28,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDaySelection() {
    if (_levelDaysData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final days = _levelDaysData!['days'] as List;
    final levelColor = _getLevelColor(_selectedLevel!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_selectedLevel daraja uchun hafta kunlarini tanlang',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...days.map((day) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => _selectDay(day['name'], day['id']),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: levelColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${day['sub_categories']?.length ?? 0} ta mashq kategoriyasi',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: levelColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${day['duration']} daq',
                        style: TextStyle(
                          color: levelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: levelColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSubCategorySelection() {
    final subCategories = _getCurrentDaySubCategories();
    final levelColor = _getLevelColor(_selectedLevel!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_selectedDay kuni uchun mashq kategoriyalari',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...subCategories.map((subCategory) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _selectSubCategory(subCategory),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: levelColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        color: levelColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        subCategory['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: levelColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildExerciseDetails() {
    final levelColor = _getLevelColor(_selectedLevel!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: levelColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: levelColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: levelColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedSubCategory!['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_selectedDay • $_selectedLevel daraja',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mashq haqida ma\'lumot',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: levelColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bu mashq turi tanangizni kuchaytirish va sog\'lom turmush tarzini qo\'llab-quvvatlash uchun mo\'ljallangan.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to exercise execution screen
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (context) => ExerciseExecutionScreen(
                          //     subCategory: _selectedSubCategory!,
                          //     level: _selectedLevel!,
                          //     day: _selectedDay!,
                          //   ),
                          // ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mashqni boshlash...'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: levelColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Mashqni boshlash',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
