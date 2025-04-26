import 'package:flutter/material.dart';

class TimeRegulationScreen extends StatelessWidget {
  const TimeRegulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaqt reglamenti'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildTimeSection(
            context,
            'Kunlik reja',
            [
              _buildTimeTile(
                context,
                'Bugungi mashg\'ulot vaqti',
                '1 soat 30 daqiqa',
                Icons.timer,
              ),
              _buildTimeTile(
                context,
                'Qolgan vaqt',
                '45 daqiqa',
                Icons.timer_outlined,
              ),
            ],
          ),
          _buildTimeSection(
            context,
            'Haftalik reja',
            [
              _buildTimeTile(
                context,
                'Haftalik maqsad',
                '10 soat',
                Icons.calendar_today,
              ),
              _buildTimeTile(
                context,
                'Bajarilgan',
                '6 soat',
                Icons.check_circle,
              ),
            ],
          ),
          _buildTimeSection(
            context,
            'Shaxsiy sozlamalar',
            [
              _buildTimeTile(
                context,
                'Kunlik limit',
                '2 soat',
                Icons.settings,
              ),
              _buildTimeTile(
                context,
                'Haftalik limit',
                '12 soat',
                Icons.settings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection(
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

  Widget _buildTimeTile(
      BuildContext context, String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.edit),
        onTap: () {},
      ),
    );
  }
}
