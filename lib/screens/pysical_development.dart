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
  final String selectedAgeGroup = '18-29 yosh';
  late TabController _genderTabController;
  late TabController _typeTabController;

  // Selected level for each gender and type
  Map<String, Map<String, String?>> _selectedLevels = {
    'boy': {
      'mandatory': null,
      'optional': null,
    },
    'girl': {
      'mandatory': null,
      'optional': null,
    },
  };

  @override
  void initState() {
    _genderTabController = TabController(length: 2, vsync: this);
    _typeTabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _genderTabController.dispose();
    _typeTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentGender = _genderTabController.index == 0 ? 'boy' : 'girl';

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant,
      appBar: AppBar(
        title: const Text('J. tayyorgarlik ko\'rsatkichlari',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        bottom: TabBar(
          controller: _genderTabController,
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
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.primary,
            child: TabBar(
              controller: _typeTabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: 'Majburiy mashqlar'),
                Tab(text: 'Ixtiyoriy mashqlar'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _typeTabController,
              children: [
                _buildTestList(
                  gender: currentGender,
                  type: 'mandatory',
                  theme: theme,
                ),
                _buildTestList(
                  gender: currentGender,
                  type: 'optional',
                  theme: theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestList({
    required String gender,
    required String type,
    required ThemeData theme,
  }) {
    // Filter test data based on type (mandatory/optional)
    final List<Map<String, String>> items =
        (testData[selectedAgeGroup]?[gender] ?? [])
            .where((item) => item['type'] == type)
            .toList();

    final selectedLevel = _selectedLevels[gender]?[type];

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
