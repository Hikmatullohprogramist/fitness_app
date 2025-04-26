import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<String> weekdays = [
    'Dushanba',
    'Seshanba',
    'Chorshanba',
    'Payshanba',
    'Juma',
    'Shanba',
    'Yakshanba'
  ];

  final Map<String, Color> dayColors = {
    'Dushanba': Colors.blue.shade200,
    'Seshanba': Colors.green.shade200,
    'Chorshanba': Colors.red.shade200,
    'Payshanba': Colors.purple.shade200,
    'Juma': Colors.orange.shade200,
    'Shanba': Colors.blue.shade200,
    'Yakshanba': Colors.lime.shade200,
  };

  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    // Default to current day of week
    final now = DateTime.now();
    _selectedDayIndex = now.weekday - 1; // 0-6 for Mon-Sun
    if (_selectedDayIndex > 6) _selectedDayIndex = 0;
  }

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
            onPressed: () {
              // Add new journal entry logic
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDiaryHeader(),
          _buildDaySelector(),
          Expanded(
            child: _buildDayContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryHeader() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: Column(
        children: [
          Text(
            'Jismoniy faoliyat kundaligi',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hafta: ${DateFormat('d MMM').format(weekStart)} - ${DateFormat('d MMM').format(weekEnd)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Oy: ${DateFormat('MMMM yyyy').format(now)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekdays.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedDayIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDayIndex = index;
                });
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? dayColors[weekdays[index]]
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                    isSelected ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(
                    weekdays[index],
                    style: TextStyle(
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayContent() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final selectedDate = weekStart.add(Duration(days: _selectedDayIndex));
    final dateStr = DateFormat('d MMM, yyyy').format(selectedDate);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: dayColors[weekdays[_selectedDayIndex]],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                '${weekdays[_selectedDayIndex]} - $dateStr',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 3, // Sample entries
                itemBuilder: (context, index) {
                  return _buildActivityEntry(
                    time: '${8 + index * 2}:00',
                    activity: _getSampleActivity(index),
                    duration: '${30 + index * 15} daqiqa',
                    intensity: _getSampleIntensity(index),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildNotesSection(),
        ],
      ),
    );
  }

  String _getSampleActivity(int index) {
    final activities = [
      'Piyoda yurish',
      'Yoga mashqlari',
      'Kuch mashqlari',
    ];
    return index < activities.length ? activities[index] : 'Mashg\'ulot';
  }

  String _getSampleIntensity(int index) {
    final intensities = ['O\'rta', 'Yuqori', 'Past'];
    return index < intensities.length ? intensities[index] : 'O\'rta';
  }

  Widget _buildActivityEntry({
    required String time,
    required String activity,
    required String duration,
    required String intensity,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Intensivlik: $intensity'),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              duration,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: const Center(
            child: Text(
              'Eslatmalar:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: const Text(
            'Bugun juda yaxshi mashg\'ulot o\'tdi. Ertaga ko\'proq vaqt ajratishim kerak.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}
