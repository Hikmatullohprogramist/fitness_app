import 'package:flutter/material.dart';

class IdealBodyScreen extends StatefulWidget {
  const IdealBodyScreen({Key? key}) : super(key: key);

  @override
  State<IdealBodyScreen> createState() => _IdealBodyScreenState();
}

class _IdealBodyScreenState extends State<IdealBodyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedHeightBoys;
  int? _selectedHeightGirls;
  final boysScrollController = ScrollController();
  final girlsScrollController = ScrollController();

  final List<Map<String, int>> boys = [
    {'height': 135, 'weight': 35},
    {'height': 140, 'weight': 43},
    {'height': 142, 'weight': 47},
    {'height': 148, 'weight': 50},
    {'height': 152, 'weight': 53},
    {'height': 156, 'weight': 54},
    {'height': 160, 'weight': 57},
    {'height': 164, 'weight': 60},
    {'height': 168, 'weight': 63},
    {'height': 172, 'weight': 64},
    {'height': 176, 'weight': 67},
    {'height': 180, 'weight': 70},
    {'height': 184, 'weight': 74},
    {'height': 188, 'weight': 77},
    {'height': 192, 'weight': 81},
    {'height': 196, 'weight': 86},
    {'height': 200, 'weight': 91},
  ];

  final List<Map<String, int>> girls = [
    {'height': 135, 'weight': 33},
    {'height': 140, 'weight': 41},
    {'height': 142, 'weight': 44},
    {'height': 148, 'weight': 46},
    {'height': 152, 'weight': 48},
    {'height': 156, 'weight': 50},
    {'height': 160, 'weight': 52},
    {'height': 164, 'weight': 55},
    {'height': 168, 'weight': 58},
    {'height': 172, 'weight': 61},
    {'height': 176, 'weight': 64},
    {'height': 180, 'weight': 67},
    {'height': 184, 'weight': 70},
    {'height': 188, 'weight': 74},
    {'height': 192, 'weight': 78},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    boysScrollController.dispose();
    girlsScrollController.dispose();
    super.dispose();
  }

  void _onHeightSelected(
      int? height, List<Map<String, int>> data, ScrollController controller) {
    if (height == null) return;
    final index = data.indexWhere((item) => item['height'] == height);
    if (index != -1) {
      controller.animateTo(
        index * 80.0, // Approximate card height
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.monitor_weight, color: Colors.white),
            const SizedBox(width: 8),
            const Text('J. rivojlanish ko\'rsatgichlari'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
              text: 'O\'g\'il bolalar',
            ),
            Tab(
              icon: Icon(Icons.female),
              text: 'Qiz bolalar',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTable(
            context,
            boys,
            Colors.blue.shade100,
            Icons.male,
            _selectedHeightBoys,
            (val) {
              setState(() => _selectedHeightBoys = val);
              _onHeightSelected(val, boys, boysScrollController);
            },
            boysScrollController,
          ),
          _buildTable(
            context,
            girls,
            Colors.pink.shade100,
            Icons.female,
            _selectedHeightGirls,
            (val) {
              setState(() => _selectedHeightGirls = val);
              _onHeightSelected(val, girls, girlsScrollController);
            },
            girlsScrollController,
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    List<Map<String, int>> data,
    Color cardColor,
    IconData icon,
    int? selectedHeight,
    ValueChanged<int?> onHeightSelected,
    ScrollController controller,
  ) {
    // Choose highlight color based on gender
    final bool isBoys = icon == Icons.male;
    final Color selectedColor = isBoys ? Colors.blue[300]! : Colors.pink[200]!;
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<int>(
            value: selectedHeight,
            decoration: InputDecoration(
              labelText: 'Bo\'yingizni tanlang',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
            items: data
                .map((item) => DropdownMenuItem<int>(
                      value: item['height'],
                      child: Text('${item['height']} sm'),
                    ))
                .toList(),
            onChanged: onHeightSelected,
            isExpanded: true,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            controller: controller,
            padding: const EdgeInsets.all(24),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final isSelected = selectedHeight == item['height'];
              return Card(
                color: isSelected ? selectedColor : cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: isSelected
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2)
                      : BorderSide.none,
                ),
                elevation: isSelected ? 6 : 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(icon, color: cardColor.darken(0.2)),
                  ),
                  title: Text('${item['height']} sm',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('${item['weight']} kg',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
