import 'package:fitness_app/models/user_model.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/workout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();
  UserModel? user;
  List<Workout> recentWorkouts = [];

  getCurrentUser() async {
    final loginUser = await authService.getUser();
    if (loginUser != null) {
      setState(() {
        user = loginUser;
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> menuItems = [
      _MenuItem('Jismoniy rivojlanganlik ko\'rsatkichlari',
          Icons.analytics_outlined, '/ideal_body'),
      _MenuItem('Jismoniy rivojlanganlik darajasi', Icons.trending_up,
          '/physical_development_level'),
      _MenuItem(
          'Jismoniy tayyorgarlik ko\'rsatkichlari', Icons.speed, '/jismoniytk'),
      _MenuItem('Professiogramma', Icons.assessment_outlined, '/progress'),
      _MenuItem('J.t daqiqalik kompleksi (animatsiya)',
          Icons.play_circle_outline, '/activity_anim'),
      _MenuItem('J. faoliyati (QR, kadr, rasm)', Icons.camera_alt_outlined,
          '/activity_qr'),
      _MenuItem(
          'Mashqlar majmuasi', Icons.sports_gymnastics_outlined, '/exercises'),
      _MenuItem(
          'Mening mashqlarim', Icons.fitness_center_outlined, '/my_exercises'),
      _MenuItem(
          'Mening mashqlarim', Icons.fitness_center_outlined, '/my_exercises'),
    ];

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildGreeting(context, user),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.1,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return _MenuCard(item: item);
              },
            ),
            const SizedBox(height: 24),
            if (recentWorkouts.isNotEmpty) ...[
              Text('So\'nggi mashg\'ulotlar',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildRecentWorkouts(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildLevelBadge(BuildContext context, String? level) {
    Color badgeColor;
    String label;
    switch (level) {
      case 'Minimal' || '1':
        badgeColor = Colors.green;
        label = 'Minimal';
        break;
      case 'Optimal' || '2':
        badgeColor = Colors.orange;
        label = 'Optimal';
        break;
      case 'Maximal' || '3':
        badgeColor = Colors.red;
        label = 'Maximal';
        break;
      default:
        badgeColor = Colors.grey;
        label = 'Nomalum';
    }
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      // onTap: () => _showEditLevelDialog(context),
      onTap: () => _showEditLevelDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: badgeColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fitness_center, color: badgeColor, size: 18),
            const SizedBox(width: 6),
            Text(
              'Daraja: $label',
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, UserModel? user) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Salom, ${user?.name.split(' ').first}!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                'Bugun mashg\'ulot qilishga tayyormisiz ?',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              buildLevelBadge(context, user?.fitnessLevel),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentWorkouts(BuildContext context) {
    return Column(
      children: recentWorkouts.take(3).map((workout) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(Icons.fitness_center,
                color: Theme.of(context).colorScheme.primary),
            title: Text(workout.type),
            subtitle: Text(
                '${workout.date.day}.${workout.date.month}.${workout.date.year}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }

  void _showEditLevelDialog(BuildContext context) async {
    final levels = ['Minimal', 'Optimal', 'Maximal'];
    String? selected = user?.fitnessLevel;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Darajani o\'gartirish'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: levels.map((level) {
              return RadioListTile<String>(
                value: level,
                groupValue: selected,
                title: Text(level),
                onChanged: (value) {
                  Navigator.of(context).pop();
                  _updateUserLevel(value!);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _updateUserLevel(String newLevel) async {
    if (user == null) return;
    // TODO: Serverga PATCH/PUT so'rov yuborish (authService.updateUserLevel)
    setState(() {
      user = user!.copyWith(fitnessLevel: newLevel);
    });
    // TODO: Secure storage'ga ham yangilash
    await authService.updateUser(user!);
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;
  _MenuItem(this.title, this.icon, this.route);
}

class _MenuCard extends StatefulWidget {
  final _MenuItem item;
  const _MenuCard({required this.item});

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () {
        Navigator.of(context).pushNamed(widget.item.route);
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.18),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: accent.withOpacity(0.35), width: 1.6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withOpacity(0.13),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(widget.item.icon, size: 36, color: accent),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
