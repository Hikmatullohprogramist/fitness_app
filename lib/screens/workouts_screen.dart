import 'package:flutter/material.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final List<Map<String, dynamic>> weekDays = const [
    {
      'name': 'Dushanba',
      'date': '15',
      'month': 'Aprel',
      'icon': Icons.calendar_today,
      'totalTime': '8 daqiqa',
      'optimalTime': 25,
      'workouts': [
        {
          'title': 'Bo\'yni mashq qilish',
          'duration': '3 daqiqa',
          'calories': '15 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': '07:00 - Ertalab',
        },
        {
          'title': 'Yelka mashqlari',
          'duration': '5 daqiqa',
          'calories': '25 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': '18:00 - Kechqurun',
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
      'workouts': [
        {
          'title': 'Yoga',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': '08:00 - Ertalab',
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
      'workouts': [
        {
          'title': 'Kuch mashqlari',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Murakkab',
          'image': 'assets/workout.jpg',
          'time': '17:00 - Kechqurun',
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
      'workouts': [
        {
          'title': 'Stretching',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': '07:30 - Ertalab',
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
      'workouts': [
        {
          'title': 'Kardio',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'O\'rta',
          'image': 'assets/workout.jpg',
          'time': '18:30 - Kechqurun',
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
      'workouts': [
        {
          'title': 'Kuch mashqlari',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Murakkab',
          'image': 'assets/workout.jpg',
          'time': '09:00 - Ertalab',
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
      'workouts': [
        {
          'title': 'Dam olish',
          'duration': '0 daqiqa',
          'calories': '0 kal',
          'difficulty': 'Oson',
          'image': 'assets/workout.jpg',
          'time': 'Dam olish kuni',
        },
      ],
    },
  ];

  int _selectedDayIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haftalik mashqlar'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
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
              itemCount: weekDays.length,
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
                              Container(
                                width: 30,
                                height: 30,
                                margin: const EdgeInsets.only(bottom: 2),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    weekDays[index]['date'],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                weekDays[index]['name'],
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
                                weekDays[index]['month'],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey[500],
                                  fontSize: 8,
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

          // Progress card
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
                            int.parse(weekDays[_selectedDayIndex]['totalTime']
                                .toString()
                                .split(' ')[0]),
                            weekDays[_selectedDayIndex]['optimalTime'],
                          ),
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getProgressText(
                          int.parse(weekDays[_selectedDayIndex]['totalTime']
                              .toString()
                              .split(' ')[0]),
                          weekDays[_selectedDayIndex]['optimalTime'],
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getProgressColor(
                            _getProgress(
                              int.parse(weekDays[_selectedDayIndex]['totalTime']
                                  .toString()
                                  .split(' ')[0]),
                              weekDays[_selectedDayIndex]['optimalTime'],
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
                      int.parse(weekDays[_selectedDayIndex]['totalTime']
                          .toString()
                          .split(' ')[0]),
                      weekDays[_selectedDayIndex]['optimalTime'],
                    ),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(
                        _getProgress(
                          int.parse(weekDays[_selectedDayIndex]['totalTime']
                              .toString()
                              .split(' ')[0]),
                          weekDays[_selectedDayIndex]['optimalTime'],
                        ),
                      ),
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Optimal vaqt: ${weekDays[_selectedDayIndex]['optimalTime']} daqiqa',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Workouts list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: weekDays[_selectedDayIndex]['workouts'].length,
              itemBuilder: (context, index) {
                final workout = weekDays[_selectedDayIndex]['workouts'][index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutInfoScreen(),
                      ),
                    );
                  },
                  child: Container(
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
                              top: 10,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
