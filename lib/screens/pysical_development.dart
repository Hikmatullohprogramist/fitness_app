import 'package:flutter/material.dart';
import '../data/test_data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhysicalDevelopmentScreen extends StatefulWidget {
  @override
  State<PhysicalDevelopmentScreen> createState() =>
      _PhysicalDevelopmentScreenState();
}

class _PhysicalDevelopmentScreenState extends State<PhysicalDevelopmentScreen>
    with TickerProviderStateMixin {
  final String selectedAgeGroup = '18-29 yosh'; // Faqat 18-29 yosh
  late TabController _tabController;

  // Selected level for each gender
  Map<String, String?> _selectedLevels = {
    'boy': null,
    'girl': null,
  };

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentGender = _tabController.index == 0 ? 'boy' : 'girl';

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant,
      appBar: AppBar(
        title: const Text('Jismoniy tayyorgarlik ko\'rsatkichlari',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.male),
              text: 'O\'g\'il',
            ),
            Tab(
              icon: Icon(Icons.female),
              text: 'Qiz',
            ),
          ],
          onTap: (_) {
            setState(() {});
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTestList(gender: 'boy', theme: theme),
          _buildTestList(gender: 'girl', theme: theme),
        ],
      ),
    );
  }

  Widget _buildTestList({required String gender, required ThemeData theme}) {
    final List<Map<String, String>> items =
        testData[selectedAgeGroup]?[gender] ?? [];
    final selectedLevel = _selectedLevels[gender];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          shadowColor: theme.shadowColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['image'] != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: item['image']!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: theme.colorScheme.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: theme.colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.fitness_center,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  item['test'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _gradeItem('III', item['III']!,
                        isHighlighted: selectedLevel == 'III', theme: theme),
                    _gradeItem('II', item['II']!,
                        isHighlighted: selectedLevel == 'II', theme: theme),
                    _gradeItem('I', item['I']!,
                        isHighlighted: selectedLevel == 'I', theme: theme),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelSelector(String gender, ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sizga mos darajani tanlang:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _levelSelectButton(gender, 'III', 'Minimal', theme),
              _levelSelectButton(gender, 'II', 'Optimal', theme),
              _levelSelectButton(gender, 'I', 'Maximal', theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _levelSelectButton(
      String gender, String level, String description, ThemeData theme) {
    final isSelected = _selectedLevels[gender] == level;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLevels[gender] = isSelected ? null : level;
        });
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              level,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradeItem(String level, String value,
      {required bool isHighlighted, required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlighted
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isHighlighted
            ? Border.all(color: theme.colorScheme.primary, width: 1)
            : null,
      ),
      child: Column(
        children: [
          Text(
            level,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isHighlighted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isHighlighted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
