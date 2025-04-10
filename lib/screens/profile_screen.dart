import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Foydalanuvchi Ismi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Professional sportchi',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProfileStat('Mashqlar', '120'),
                    _buildProfileStat('Yutuqlar', '15'),
                    _buildProfileStat('Kunlar', '30'),
                  ],
                ),
              ],
            ),
          ),

          // Profile Settings
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil sozlamalari',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildSettingTile(
                  context,
                  'Shaxsiy ma\'lumotlar',
                  Icons.person,
                  () {
                    // Navigate to personal info
                  },
                ),
                _buildSettingTile(
                  context,
                  'Mashq rejasi',
                  Icons.fitness_center,
                  () {
                    // Navigate to workout plan
                  },
                ),
                _buildSettingTile(
                  context,
                  'Bildirishnomalar',
                  Icons.notifications,
                  () {
                    // Navigate to notifications
                  },
                ),
                _buildSettingTile(
                  context,
                  'Til',
                  Icons.language,
                  () {
                    // Navigate to language settings
                  },
                ),
              ],
            ),
          ),

          // Account Settings
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hisob sozlamalari',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildSettingTile(
                  context,
                  'Parolni o\'zgartirish',
                  Icons.lock,
                  () {
                    // Navigate to change password
                  },
                ),
                _buildSettingTile(
                  context,
                  'Xavfsizlik',
                  Icons.security,
                  () {
                    // Navigate to security settings
                  },
                ),
                _buildSettingTile(
                  context,
                  'Chiqish',
                  Icons.logout,
                  () {
                    // Logout
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
