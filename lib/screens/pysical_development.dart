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
    print((testData[selectedAgeGroup]?[gender] ?? [])
        .where((item) => item['type'] == type)
        .toList());
    // Filter test data based on type (mandatory/optional)
    final List<Map<String, dynamic>> items =
        (testData[selectedAgeGroup]?[gender] ?? [])
            .where((item) => item['type'] == type)
            .toList();

    final selectedLevel = _selectedLevels[gender]?[type];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final test = items[index];
        final ageGroups = test['age'];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test['test'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(),
                const SizedBox(height: 8),
                // Yoshlar
                Text(
                  "18-24 yosh",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _gradeBox("I", ageGroups["yoshlar"]?["I"], theme),
                    _gradeBox("II", ageGroups["yoshlar"]?["II"], theme),
                    _gradeBox("III", ageGroups["yoshlar"]?["III"], theme),
                  ],
                ),
                const SizedBox(height: 14),
                // Kattalar
                Text(
                  "25-29 yosh",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _gradeBox("I", ageGroups["kattalar"]?["I"], theme),
                    _gradeBox("II", ageGroups["kattalar"]?["II"], theme),
                    _gradeBox("III", ageGroups["kattalar"]?["III"], theme),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _gradeBox(String label, String? value, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? "-",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
