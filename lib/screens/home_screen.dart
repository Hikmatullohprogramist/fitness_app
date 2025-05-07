import 'package:fitness_app/screens/pysical_development.dart';
import 'package:fitness_app/screens/workout_category_screen.dart';
import 'package:fitness_app/screens/workouts_screen.dart';
import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/user.dart';
import 'package:fitness_app/widgets/menu_card.dart';
import 'package:fitness_app/widgets/time_progress_bar.dart';
import 'package:fitness_app/widgets/achievement_card.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final List<Workout> recentWorkouts;

  const HomeScreen({
    Key? key,
    required this.user,
    required this.recentWorkouts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> menuItems = [
      _MenuItem('Jismoniy rivojlanganlik kòrsatkichlari', Icons.monitor_weight,
          '/ideal-body'),
      _MenuItem('Jismoniy tayyorgarlik ko‘rsatkichlari', Icons.fitness_center,
          '/jismoniytk'),
      _MenuItem('Professiogramma', Icons.assessment, '/progress'),
      _MenuItem('J.t daqiqalik kompleksi (animatsiya)', Icons.directions_run,
          '/activity_anim'),
      _MenuItem('J. faoliyati (QR, kadr, rasm)', Icons.qr_code, '/activity_qr'),
      _MenuItem('Mashqlar majmuasi', Icons.sports_gymnastics, '/exercises'),
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
              Text('So‘nggi mashg‘ulotlar',
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

  Widget _buildGreeting(BuildContext context, User user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage:
              user.profileImageUrl != null && user.profileImageUrl.isNotEmpty
                  ? NetworkImage(user.profileImageUrl)
                  : null,
          child: user.profileImageUrl == null || user.profileImageUrl.isEmpty
              ? Icon(Icons.person,
                  size: 32, color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Salom, ${user.name.split(' ').first}!',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 4),
              Text('Bugun mashg‘ulot qilishga tayyormisiz?',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14)),
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
