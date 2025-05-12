import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PhysicalTrainingScreen extends StatefulWidget {
  const PhysicalTrainingScreen({Key? key}) : super(key: key);

  @override
  State<PhysicalTrainingScreen> createState() => _PhysicalTrainingScreenState();
}

class _PhysicalTrainingScreenState extends State<PhysicalTrainingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Example data - replace with your actual data
  final Map<String, List<Map<String, dynamic>>> exercises = {
    'warmup': [
      {
        'title': 'Bo\'yni mashq qilish',
        'description': 'Bo\'yni aylantirish va egish mashqlari',
        'animation': 'assets/animations/loading.json',
        'duration': '5 daqiqa',
        'repetitions': '10 marta',
      },
      {
        'title': 'Yelka mashqlari',
        'description': 'Yelkalarni aylantirish va cho\'zish',
        'animation': 'assets/animations/loading.json',
        'duration': '5 daqiqa',
        'repetitions': '12 marta',
      },
    ],
    'strength': [
      {
        'title': 'Mana qo\'yish',
        'description': 'To\'g\'ri mana qo\'yish texnikasi',
        'animation': 'assets/animations/loading.json',
        'duration': '10 daqiqa',
        'repetitions': '3 set, 15 marta',
      },
      {
        'title': 'Squat',
        'description': 'To\'g\'ri squat texnikasi',
        'animation': 'assets/animations/loading.json',
        'duration': '10 daqiqa',
        'repetitions': '3 set, 20 marta',
      },
    ],
    'stretching': [
      {
        'title': 'Oyoq cho\'zish',
        'description': 'Oyoqlarni cho\'zish mashqlari',
        'animation': 'assets/animations/loading.json',
        'duration': '8 daqiqa',
        'repetitions': 'Har bir oyoq uchun 5 marta',
      },
      {
        'title': 'Orqa cho\'zish',
        'description': 'Orqani cho\'zish mashqlari',
        'animation': 'assets/animations/loading.json',
        'duration': '8 daqiqa',
        'repetitions': '10 marta',
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
        title: const Text('Jismoniy tayyorgarlik kompleksi'),
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
              icon: Icon(Icons.wb_sunny),
              text: 'Dastlabki',
            ),
            Tab(
              icon: Icon(Icons.fitness_center),
              text: 'Kuch',
            ),
            Tab(
              icon: Icon(Icons.accessibility_new),
              text: 'Cho\'zish',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExerciseList('warmup', theme),
          _buildExerciseList('strength', theme),
          _buildExerciseList('stretching', theme),
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
                child: Container(
                  height: 200,
                  color: theme.colorScheme.surfaceVariant,
                  child: Lottie.asset(
                    exercise['animation'],
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      exercise['description'],
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoChip(
                            icon: Icons.timer,
                            label: exercise['duration'],
                            theme: theme,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            icon: Icons.repeat,
                            label: exercise['repetitions'],
                            theme: theme,
                          ),
                        ],
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

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
