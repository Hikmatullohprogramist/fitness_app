import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Weekly Progress
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haftalik progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildProgressCard(
                  context,
                  'Mashqlar soni',
                  '28/35',
                  0.8,
                  Colors.blue,
                ),
                _buildProgressCard(
                  context,
                  'Kaloriya',
                  '3500/4000',
                  0.875,
                  Colors.red,
                ),
                _buildProgressCard(
                  context,
                  'Vaqt',
                  '12/15 soat',
                  0.8,
                  Colors.green,
                ),
              ],
            ),
          ),

          // Monthly Overview
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Oylik ko\'rinish',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  context,
                  'Jami mashqlar',
                  '120',
                  Icons.fitness_center,
                ),
                _buildStatCard(
                  context,
                  'O\'rtacha kunlik vaqt',
                  '45 min',
                  Icons.timer,
                ),
                _buildStatCard(
                  context,
                  'Yakunlangan kunlar',
                  '25/30',
                  Icons.calendar_today,
                ),
              ],
            ),
          ),

          // Achievement Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yutuqlar statistikasi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildAchievementStat(
                  context,
                  'Ketma-ket kunlar',
                  '5 kun',
                  Icons.star,
                ),
                _buildAchievementStat(
                  context,
                  'Jami yutuqlar',
                  '12 ta',
                  Icons.emoji_events,
                ),
                _buildAchievementStat(
                  context,
                  'Eng yaxshi kun',
                  '800 kaloriya',
                  Icons.local_fire_department,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    String title,
    String value,
    double progress,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _buildAchievementStat(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
