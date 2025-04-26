import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yordam va qo\'llab-quvvatlash'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildHelpSection(
            context,
            'Tez-tez so\'raladigan savollar',
            [
              _buildHelpTile(
                context,
                'Qanday qilib mashqlarni boshlash mumkin?',
                Icons.help_outline,
              ),
              _buildHelpTile(
                context,
                'Mashqlar rejasini qanday o\'zgartirish mumkin?',
                Icons.help_outline,
              ),
              _buildHelpTile(
                context,
                'Statistikani qanday ko\'rish mumkin?',
                Icons.help_outline,
              ),
            ],
          ),
          _buildHelpSection(
            context,
            'Bog\'lanish',
            [
              _buildHelpTile(
                context,
                'Telefon: +998 90 123 45 67',
                Icons.phone,
              ),
              _buildHelpTile(
                context,
                'Email: support@fitnessapp.uz',
                Icons.email,
              ),
              _buildHelpTile(
                context,
                'Telegram: @fitnessapp_support',
                Icons.telegram,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(
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

  Widget _buildHelpTile(BuildContext context, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
