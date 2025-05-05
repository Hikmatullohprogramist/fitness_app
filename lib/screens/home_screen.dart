import 'package:fitness_app/screens/pysical_development.dart';
import 'package:fitness_app/screens/workout_category_screen.dart';
import 'package:fitness_app/screens/workouts_screen.dart';
import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/user.dart';
import 'package:fitness_app/widgets/menu_card.dart';
import 'package:fitness_app/widgets/time_progress_bar.dart';
import 'package:fitness_app/widgets/achievement_card.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final List<Workout> recentWorkouts;

  const HomeScreen({
    Key? key,
    required this.user,
    required this.recentWorkouts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF00796B);
    final Color secondary = const Color(0xFF388E3C);
    final Color background = const Color(0xFFF5F5F5);
    final Color accent = const Color(0xFFFFC107);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(primary),
              const SizedBox(height: 24),
              _buildQuickStats(primary, accent),
              const SizedBox(height: 24),
              _buildRecentWorkouts(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salom, ${user.name}!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bugun mashg‘ulot qilishga tayyormisiz?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(Color primary, Color accent) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tezkor statistikalar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    'Mashg‘ulotlar', '${recentWorkouts.length}', primary),
                _buildStatItem('Vaqt', '2 min', primary),
                _buildStatItem('Yurgan', '100 m', primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color primary) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentWorkouts(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.show_chart,
        'title': 'Jismoniy rivojlanish',
        'subtitle': 'Kunlik progress',
        'color': const Color(0xFF00796B),
        'goto': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhysicalDevelopmentScreen(),
            ),
          );
        }
      },
      {
        'icon': Icons.school,
        'title': 'Professiogramma',
        'subtitle': 'Kasbiy mezonlar',
        'color': const Color(0xFF388E3C),
        'goto': () {}
      },
      {
        'icon': Icons.fitness_center,
        'title': 'Mashg‘ulotlar',
        'subtitle': 'Mashqlar ro‘yxati',
        'color': const Color(0xFFFFC107),
        'goto': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Mashg‘ulotlar'),
                ),
                body: const WorkoutsScreen(),
              ),
            ),
          );
        }
      },
      {
        'icon': Icons.track_changes,
        'title': 'Tayyorgarlik',
        'subtitle': 'Joriy daraja',
        'color': const Color(0xFF7B1FA2),
        'goto': () {}
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: item['goto'],
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: item['color'].withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'],
                    size: 40,
                    color: item['color'],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['subtitle'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
