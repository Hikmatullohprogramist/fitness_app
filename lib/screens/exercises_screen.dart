import 'package:flutter/material.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({Key? key}) : super(key: key);

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Example data - replace with your actual data
  final Map<String, List<Map<String, dynamic>>> exercises = {
    'individual': [
      {
        'title': 'Yugurish',
        'description': '30 daqiqa yugurish',
        'image': 'assets/images/running.jpg',
        'difficulty': 'Oson',
      },
      {
        'title': 'Shpagat',
        'description': 'Har bir oyoq uchun 5 daqiqa',
        'image': 'assets/images/split.jpg',
        'difficulty': 'O\'rta',
      },
    ],
    'partner': [
      {
        'title': 'Juftlikda yugurish',
        'description': '20 daqiqa juftlikda yugurish',
        'image': 'assets/images/partner_running.jpg',
        'difficulty': 'Oson',
      },
      {
        'title': 'Juftlikda mashq',
        'description': '15 daqiqa juftlikda mashq',
        'image': 'assets/images/partner_exercise.jpg',
        'difficulty': 'O\'rta',
      },
    ],
    'team': [
      {
        'title': 'Jamoaviy yugurish',
        'description': '40 daqiqa jamoaviy yugurish',
        'image': 'assets/images/team_running.jpg',
        'difficulty': 'Oson',
      },
      {
        'title': 'Jamoaviy mashq',
        'description': '30 daqiqa jamoaviy mashq',
        'image': 'assets/images/team_exercise.jpg',
        'difficulty': 'O\'rta',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      body: TabBarView(
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
    final categoryExercises = exercises[category] ?? [];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  exercise['image'],
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
                            exercise['title'],
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
                            exercise['difficulty'],
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
                      exercise['description'],
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
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
}
