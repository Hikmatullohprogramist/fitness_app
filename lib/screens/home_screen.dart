import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/menu_card.dart';
import 'package:fitness_app/widgets/time_progress_bar.dart';
import 'package:fitness_app/widgets/achievement_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _dailyTimeLimit = 25; // in minutes
  final double _usedTime = 0; // Track used time

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Welcome Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salom, Foydalanuvchi!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Bugun qanday mashqlar qilmoqchisiz?'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Time Progress Bar
          TimeProgressBar(usedTime: _usedTime, dailyTimeLimit: _dailyTimeLimit),

          // Quick Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  context,
                  'Kunlik mashqlar',
                  '5/8',
                  Icons.fitness_center,
                ),
                _buildStatCard(
                  context,
                  'Kaloriya',
                  '450',
                  Icons.local_fire_department,
                ),
                _buildStatCard(
                  context,
                  'Vaqt',
                  '25 min',
                  Icons.timer,
                ),
              ],
            ),
          ),

          // Main Menu Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                MenuCard(
                  icon: Icons.show_chart,
                  title: 'Jismoniy rivojlanish darajasi',
                  subtitle: 'Kunlik progress',
                  onTap: () => _navigateToSection(0),
                ),
                MenuCard(
                  icon: Icons.school,
                  title: 'Professiogramma',
                  subtitle: 'Kasbiy mezonlar',
                  onTap: () => _navigateToSection(1),
                ),
                MenuCard(
                  icon: Icons.fitness_center,
                  title: 'Individual mashg\'ulotlar',
                  subtitle: 'Mashqlar ro\'yxati',
                  onTap: () => _navigateToSection(2),
                ),
                MenuCard(
                  icon: Icons.track_changes,
                  title: 'Jismoniy tayyorgarlik',
                  subtitle: 'Joriy daraja',
                  onTap: () => _navigateToSection(3),
                ),
              ],
            ),
          ),

          // Recent Achievements
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yaqinda qo\'lga kiritilgan yutuqlar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: const Row(
                    children: [
                      AchievementCard(
                        title: '5 kun ketma-ket',
                        description: 'Mashqlarni davom ettirish',
                        icon: Icons.star,
                        color: Colors.amber,
                      ),
                      AchievementCard(
                        title: '1000 kaloriya',
                        description: 'Yakunlangan mashqlar',
                        icon: Icons.local_fire_department,
                        color: Colors.red,
                      ),
                      AchievementCard(
                        title: 'Yangi mashq',
                        description: 'Qo\'shilgan mashq',
                        icon: Icons.add_circle,
                        color: Colors.green,
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
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSection(int index) {
    // Navigate to respective sections
  }
}
