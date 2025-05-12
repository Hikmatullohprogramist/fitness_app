import 'package:flutter/material.dart';

class PhysicalDevelopmentLevelScreen extends StatefulWidget {
  const PhysicalDevelopmentLevelScreen({super.key});

  @override
  State<PhysicalDevelopmentLevelScreen> createState() =>
      _PhysicalDevelopmentLevelScreenState();
}

class _PhysicalDevelopmentLevelScreenState
    extends State<PhysicalDevelopmentLevelScreen> {
  String? _selectedLevel;
  final Map<String, Map<String, dynamic>> _levelData = {
    'Minimal': {
      'color': Colors.green,
      'description': 'Boshlang\'ich daraja',
      'timeRegulation': '15-20 daqiqa',
      'icon': Icons.trending_up,
    },
    'Optimal': {
      'color': Colors.orange,
      'description': 'O\'rta daraja',
      'timeRegulation': '30-40 daqiqa',
      'icon': Icons.trending_flat,
    },
    'Maximal': {
      'color': Colors.red,
      'description': 'Yuqori daraja',
      'timeRegulation': '45-60 daqiqa',
      'icon': Icons.trending_down,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jismoniy rivojlanganlik darajasi'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'O\'zingizning jismoniy rivojlanganlik darajangizni tanlang:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ..._levelData.entries.map((entry) {
                final level = entry.key;
                final data = entry.value;
                final isSelected = _selectedLevel == level;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLevel = level;
                      });
                      _showTimeRegulationDialog(
                          context, data['timeRegulation']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? data['color'].withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? data['color']
                              : Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: data['color'].withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              data['icon'],
                              color: data['color'],
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data['description'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: data['color'],
                              size: 28,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeRegulationDialog(BuildContext context, String timeRegulation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaqt reglamenti'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.timer,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Sizning mashg\'ulot vaqtingiz:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              timeRegulation,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bu vaqtda mashg\'ulot qilish tavsiya etiladi',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tushundim'),
          ),
        ],
      ),
    );
  }
}
