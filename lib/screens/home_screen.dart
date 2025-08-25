import 'package:fitness_app/models/user_model.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/services/exercise_stats_service.dart';
import 'package:fitness_app/step_counter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

  // Removed unused _updateUserLevel

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
      _MenuItem('J.t daqiqalari kompleksi (animatsiya 2D, 3D)',
          "assets/animations/jtd.json", '/activity_anim'),
      _MenuItem('J.t daqiqalari (QR, rasm)', "assets/animations/qr_code.json",
          '/activity_qr'),
      _MenuItem('Mashqlar majmuasi', "assets/animations/mashqlarrr.json",
          '/exercises'),
      _MenuItem('Mening mashg\'ulotlarim', "assets/animations/speed_run-2.json",
          '/my_exercises'),
      _MenuItem('Kaloriya Kalkulyatori', "assets/animations/clock.json",
          '/calorie_calculator'),
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
                    _buildMenuGrid(
                      menuItems,
                    ),
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
              _buildStatRow(
                'MET',
                dailyStats!['MET']?.toString() ?? '0',
                Icons.check_circle,
              ),
            ],
            ModernStepCounter()
          ],
        ),
      ),
    );
  }

  // Removed unused _buildInfoRow

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
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height; // unused

    // Responsive grid configuration with more conservative aspect ratios
    int crossAxisCount;
    double childAspectRatio;
    double spacing;

    if (screenWidth < 360) {
      // Very small phones
      crossAxisCount = 2;
      childAspectRatio = 0.65; // Taller cards to fit text
      spacing = 10;
    } else if (screenWidth < 600) {
      // Mobile phones (portrait and small landscape)
      crossAxisCount = 2;
      childAspectRatio = 0.75; // Taller cards to prevent text clipping
      spacing = 12;
    } else if (screenWidth < 900) {
      // Tablets and large phones
      crossAxisCount = 3;
      childAspectRatio = 0.9; // Fixed aspect ratio for tablets
      spacing = 16;
    } else {
      // Large tablets and desktop
      crossAxisCount = 4;
      childAspectRatio = 1.0; // Fixed aspect ratio for desktop
      spacing = 20;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _MenuCard(item: items[index]);
      },
    );
  }

  // Removed unused _showEditLevelDialog
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

class _MenuCardState extends State<_MenuCard> {
  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth;
        final double iconSize =
            cardWidth.clamp(120, 180) * 0.5; // responsive icon
        final double titleFontSize = cardWidth < 160 ? 12 : 14;
        final double circlePadding = cardWidth < 160 ? 12 : 16;

        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(widget.item.route);
          },
          borderRadius: BorderRadius.circular(24),
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
            child: ClipRect(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withOpacity(0.13),
                    ),
                    padding: EdgeInsets.all(circlePadding),
                    child: widget.item.icon is IconData
                        ? Icon(widget.item.icon,
                            size: iconSize * 0.6, color: accent)
                        : Lottie.asset(
                            widget.item.icon,
                            width: iconSize,
                            height: iconSize,
                            repeat: false,
                            fit: BoxFit.contain,
                          ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.item.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
