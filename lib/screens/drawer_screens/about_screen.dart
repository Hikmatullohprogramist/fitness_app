import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ilova haqida'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/app_icon.png'),
          ),
          const SizedBox(height: 16),
          Text(
            'Fitness App',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text('Versiya 1.0.0'),
          const SizedBox(height: 32),
          _buildAboutSection(
            context,
            'Ilova haqida',
            'Bu ilova sizning jismoniy tayyorgarligingizni kuzatish va yaxshilash uchun yaratilgan. Unda turli xil mashqlar, statistikalar va yutuqlar mavjud.',
          ),
          _buildAboutSection(
            context,
            'Dasturchilar',
            'Fitness App jamoasi',
          ),
          _buildAboutSection(
            context,
            'Mualliflik huquqi',
            '© 2024 Fitness App. Barcha huquqlar himoyalangan.',
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(
      BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';