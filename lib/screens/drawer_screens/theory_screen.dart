import 'package:flutter/material.dart';

class TheoryScreen extends StatelessWidget {
  const TheoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nazariy ma\'lumot'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildTheorySection(
            context,
            'Mashqlar nazariyasi',
            [
              _buildTheoryTile(
                context,
                'Jismoniy rivojlanish jadvali',
                'Mashqlarni qanday qilib to\'g\'ri bajarish kerak',
                Icons.fitness_center,
              ),
              _buildTheoryTile(
                context,
                'Professiogramma',
                'Mashqlarni qanday qilib to\'g\'ri bajarish kerak',
                Icons.directions_run,
              ),
              _buildTheoryTile(
                context,
                'Cho\'zish mashqlari',
                'Cho\'zish mashqlarining ahamiyati',
                Icons.accessibility_new,
              ),
            ],
          ),
          _buildTheorySection(
            context,
            'Fitnes maslahatlari',
            [
              _buildTheoryTile(
                context,
                'Ovqatlanish',
                'To\'g\'ri ovqatlanish qoidalari',
                Icons.restaurant,
              ),
              _buildTheoryTile(
                context,
                'Dam olish',
                'Dam olishning ahamiyati',
                Icons.bedtime,
              ),
              _buildTheoryTile(
                context,
                'Motivatsiya',
                'Motivatsiyani saqlash usullari',
                Icons.psychology,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTheorySection(
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

  Widget _buildTheoryTile(
      BuildContext context, String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
