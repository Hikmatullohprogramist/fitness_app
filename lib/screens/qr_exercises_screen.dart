import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRExercisesScreen extends StatefulWidget {
  const QRExercisesScreen({Key? key}) : super(key: key);

  @override
  State<QRExercisesScreen> createState() => _QRExercisesScreenState();
}

class _QRExercisesScreenState extends State<QRExercisesScreen> {
  // Example data - replace with your actual data
  final List<Map<String, dynamic>> exercises = [
    {
      'title': 'Bo\'yni mashq qilish',
      'description': 'Bo\'yni aylantirish va egish mashqlari',
      'qrData': 'exercise://neck_stretch',
      'duration': '5 daqiqa',
      'repetitions': '10 marta',
      'category': 'Dastlabki',
    },
    {
      'title': 'Yelka mashqlari',
      'description': 'Yelkalarni aylantirish va cho\'zish',
      'qrData': 'exercise://shoulder_stretch',
      'duration': '5 daqiqa',
      'repetitions': '12 marta',
      'category': 'Dastlabki',
    },
    {
      'title': 'Mana qo\'yish',
      'description': 'To\'g\'ri mana qo\'yish texnikasi',
      'qrData': 'exercise://pushup',
      'duration': '10 daqiqa',
      'repetitions': '3 set, 15 marta',
      'category': 'Kuch',
    },
    {
      'title': 'Squat',
      'description': 'To\'g\'ri squat texnikasi',
      'qrData': 'exercise://squat',
      'duration': '10 daqiqa',
      'repetitions': '3 set, 20 marta',
      'category': 'Kuch',
    },
    {
      'title': 'Oyoq cho\'zish',
      'description': 'Oyoqlarni cho\'zish mashqlari',
      'qrData': 'exercise://leg_stretch',
      'duration': '8 daqiqa',
      'repetitions': 'Har bir oyoq uchun 5 marta',
      'category': 'Cho\'zish',
    },
    {
      'title': 'Orqa cho\'zish',
      'description': 'Orqani cho\'zish mashqlari',
      'qrData': 'exercise://back_stretch',
      'duration': '8 daqiqa',
      'repetitions': '10 marta',
      'category': 'Cho\'zish',
    },
  ];

  String _selectedCategory = 'Barchasi';

  List<String> get categories {
    final Set<String> uniqueCategories = {'Barchasi'};
    for (var exercise in exercises) {
      uniqueCategories.add(exercise['category']);
    }
    return uniqueCategories.toList();
  }

  List<Map<String, dynamic>> get filteredExercises {
    if (_selectedCategory == 'Barchasi') {
      return exercises;
    }
    return exercises.where((e) => e['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Kodli Mashqlar'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                exercise['description'],
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildInfoChip(
                                    icon: Icons.timer,
                                    label: exercise['duration'],
                                    theme: theme,
                                  ),
                                  _buildInfoChip(
                                    icon: Icons.repeat,
                                    label: exercise['repetitions'],
                                    theme: theme,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: exercise['qrData'],
                            version: QrVersions.auto,
                            size: 100,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
