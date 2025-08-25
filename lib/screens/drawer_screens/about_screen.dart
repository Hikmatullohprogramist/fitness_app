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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/icon/icon.jpg'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'OptiForma',
              style: Theme.of(context).textTheme.headlineMedium,
              // textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          const Center(child: Text('Versiya 1.0.0')),
          const SizedBox(height: 32),
          _buildAboutSection(
            context,
            'Ilova haqida',
            'Bu ilova oliy ta\'lim muassasalari talabalarining jismoniy tayyorgarlik darajasiga ko\'ra mashg\'ulotlarini individuallashtirish va kasbiy-amaliy jismoniy tayyorgarligini optimallashtirish maqsadida yaratilgan ',
          ),
          _buildAboutSection(
            context,
            'Dastur asoschisi',
            'Qodirova Shahlo Shavkatjon qizi',
          ),
          _buildAboutSection(
            context,
            'Dasturchilar',
            'OptiForma jamoasi',
          ),
          _buildAboutSection(
            context,
            'Mualliflik huquqi',
            '© 2025 OptiForma. Barcha huquqlar himoyalangan.',
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
