import 'package:flutter/material.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Barchasi',
      'icon': Icons.fitness_center,
    },
    {
      'name': 'Kuch mashqlari',
      'icon': Icons.sports_gymnastics,
    },
    {
      'name': 'Kardio',
      'icon': Icons.directions_run,
    },
    {
      'name': 'Yoga',
      'icon': Icons.self_improvement,
    },
    {
      'name': 'Stretching',
      'icon': Icons.accessibility_new,
    },
  ];

  int _selectedCategoryIndex = 0;
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedCategoryIndex;
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
                          : Theme.of(context).cardColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                categories[index]['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                categories[index]['name'],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
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
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              onStepContinue: () {
                if (_currentStep < 4) {
                  setState(() {
                    _currentStep++;
                  });
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                }
              },
              steps: List.generate(
                5,
                (index) => Step(
                  title: Text(
                    'Mashg\'ulot ${index + 1}',
                    style: TextStyle(
                      color: _currentStep == index
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Color(0xFFE0F7F4), Color(0xFFF8F8F8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            AssetImage('assets/images/workout_example.png'),
                      ),
                      title: const Text(
                        'Kunlik mashg\'ulot',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: const [
                          Icon(Icons.timer_outlined, size: 14),
                          SizedBox(width: 4),
                          Text('45 daqiqa'),
                          SizedBox(width: 8),
                          Icon(Icons.repeat, size: 14),
                          SizedBox(width: 4),
                          Text('3 marta'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkoutInfoScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  isActive: _currentStep >= index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
