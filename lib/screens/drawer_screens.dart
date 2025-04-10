import 'package:flutter/material.dart';

// Settings Screen
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

// Help & Support Screen
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

// About Screen
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

// Theory Section Screen
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
                'Kuch mashqlari',
                'Kuch mashqlarining asoslari va texnikasi',
                Icons.fitness_center,
              ),
              _buildTheoryTile(
                context,
                'Kardio mashqlari',
                'Kardio mashqlarining foydalari va turlari',
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

// Time Regulation Screen
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

// Self Assessment Screen
class SelfAssessmentScreen extends StatelessWidget {
  const SelfAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O\'z-o\'zini baholash'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildAssessmentSection(
            context,
            'Jismoniy holat',
            [
              _buildAssessmentTile(
                context,
                'Kuch',
                '4/5',
                Icons.fitness_center,
              ),
              _buildAssessmentTile(
                context,
                'Chidamlilik',
                '3/5',
                Icons.directions_run,
              ),
              _buildAssessmentTile(
                context,
                'Moslashuvchanlik',
                '4/5',
                Icons.accessibility_new,
              ),
            ],
          ),
          _buildAssessmentSection(
            context,
            'Ruhiy holat',
            [
              _buildAssessmentTile(
                context,
                'Motivatsiya',
                '5/5',
                Icons.psychology,
              ),
              _buildAssessmentTile(
                context,
                'Kayfiyat',
                '4/5',
                Icons.mood,
              ),
              _buildAssessmentTile(
                context,
                'Stress darajasi',
                '2/5',
                Icons.self_improvement,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentSection(
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

  Widget _buildAssessmentTile(
      BuildContext context, String title, String rating, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: Text(
          rating,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        onTap: () {},
      ),
    );
  }
}

// Journal Screen
class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mening jurnalim'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildJournalEntry(
            context,
            'Mashg\'ulot #${index + 1}',
            'Bugungi mashg\'ulot juda yaxshi o\'tdi. Kuch mashqlarini bajarishda yaxshi natijalarga erishdim.',
            DateTime.now().subtract(Duration(days: index)),
          );
        },
      ),
    );
  }

  Widget _buildJournalEntry(
      BuildContext context, String title, String content, DateTime date) {
    return Card(
      margin: const EdgeInsets.all(8),
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
            Text(content),
            const SizedBox(height: 8),
            Text(
              '${date.day}.${date.month}.${date.year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
