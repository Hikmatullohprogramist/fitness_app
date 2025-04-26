import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sozlamalar'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSettingSection(
            context,
            'Umumiy sozlamalar',
            [
              _buildSettingTile(
                context,
                'Til',
                'O\'zbek',
                Icons.language,
                    () {},
              ),
              _buildSettingTile(
                context,
                'Tema',
                'Sistema',
                Icons.palette,
                    () {},
              ),
              _buildSettingTile(
                context,
                'Bildirishnomalar',
                'Yoqilgan',
                Icons.notifications,
                    () {},
              ),
            ],
          ),
          _buildSettingSection(
            context,
            'Hisob sozlamalari',
            [
              _buildSettingTile(
                context,
                'Parolni o\'zgartirish',
                null,
                Icons.lock,
                    () {},
              ),
              _buildSettingTile(
                context,
                'Xavfsizlik',
                null,
                Icons.security,
                    () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingTile(
      BuildContext context,
      String title,
      String? subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
