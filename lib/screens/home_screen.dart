import 'package:fitness_app/models/user_model.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/services/exercise_stats_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  final exerciseStatsService = ExerciseStatsService();
  UserModel? user;
  Map<String, dynamic>? userStats;
  Map<String, dynamic>? dailyStats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get user data
      final loginUser = await authService.getUser();

      // Get user stats
      final stats = await exerciseStatsService.getUserStats();

      // Get daily stats
      final daily = await exerciseStatsService.getDailyStats();

      if (mounted) {
        setState(() {
          user = loginUser;
          userStats = stats;
          dailyStats = daily;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xatolik yuz berdi: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateUserLevel(int newLevel) async {
    if (user == null) return;

    try {
      setState(() {
        user = user!.copyWith(fitnessLevel: newLevel);
      });

      await authService.updateUser(user!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daraja muvaffaqiyatli yangilandi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xatolik yuz berdi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> menuItems = [
      _MenuItem('Jismoniy rivojlanganlik ko\'rsatkichlari',
          "assets/animations/menu_2.json", '/ideal_body'),
      _MenuItem('Jismoniy tayyorgarlik darajasi',
          "assets/animations/menu_1.json", '/physical_development_level'),
      _MenuItem('Jismoniy tayyorgarlik ko\'rsatkichlari',
          "assets/animations/menu_4.json", '/jismoniytk'),
      _MenuItem('Professiogramma', "assets/animations/professiogramma.json",
          '/progress'),
      _MenuItem('J.t daqiqalik kompleksi (animatsiya)',
          "assets/animations/jtd.json", '/activity_anim'),
      _MenuItem('J. faoliyati (QR, kadr, rasm)',
          "assets/animations/qr_code.json", '/activity_qr'),
      _MenuItem(
          'Mashqlar majmuasi', "assets/animations/mashqlar.json", '/exercises'),
      _MenuItem('Mening mashqlarim', "assets/animations/my_exercise.json",
          '/my_exercises'),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (userStats != null) _buildStats(),
                    const SizedBox(height: 24),
                    _buildMenuGrid(menuItems),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStats() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bugungi statistika',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (dailyStats != null) ...[
              _buildStatRow(
                'Mashg\'ulotlar soni',
                dailyStats!['total_exercises']?.toString() ?? '0',
                Icons.fitness_center,
              ),
              _buildStatRow(
                'Jami vaqt',
                '${dailyStats!['total_duration'] ?? 0} daqiqa',
                Icons.timer,
              ),
              _buildStatRow(
                'Yakunlangan mashg\'ulotlar',
                dailyStats!['completed_exercises']?.toString() ?? '0',
                Icons.check_circle,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(
    List<_MenuItem> items,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.sizeOf(context).width /
            (MediaQuery.of(context).size.height / 1.9),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _MenuCard(item: items[index]);
      },
    );
  }

  void _showEditLevelDialog(BuildContext context) async {
    final levels = [1, 2, 3];
    int? selected = user?.fitnessLevel;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Darajani o\'gartirish'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: levels.map((level) {
              return RadioListTile<int>(
                value: level,
                groupValue: selected,
                title: Text(level.toString()),
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
}

class _MenuItem {
  final String title;
  final dynamic icon;
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
                child: widget.item.icon is IconData
                    ? Icon(widget.item.icon, size: 36, color: accent)
                    : Lottie.asset(widget.item.icon, width: 120, height: 120),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
