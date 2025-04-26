import 'package:flutter/material.dart';

class SelfAssessmentScreen extends StatelessWidget {
  SelfAssessmentScreen({super.key});
  final List<Map<String, dynamic>> dailyAssessments = [
    {
      'date': '2024-03-01',
      'physical': {
        'Kuch': '4/5',
        'Chidamlilik': '3/5',
        'Moslashuvchanlik': '4/5'
      },
      'mental': {
        'Motivatsiya': '5/5',
        'Kayfiyat': '4/5',
        'Stress darajasi': '2/5'
      },
    },
    {
      'date': '2024-03-02',
      'physical': {
        'Kuch': '5/5',
        'Chidamlilik': '4/5',
        'Moslashuvchanlik': '5/5'
      },
      'mental': {
        'Motivatsiya': '4/5',
        'Kayfiyat': '5/5',
        'Stress darajasi': '1/5'
      },
    },
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      appBar: AppBar(
        title: const Text('O\'z-o\'zini baholash'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // _buildAssessmentSection(
          //   context,
          //   'Jismoniy holat',
          //   [
          //     _buildAssessmentTile(
          //       context,
          //       'Kuch',
          //       '4/5',
          //       Icons.fitness_center,
          //     ),
          //     _buildAssessmentTile(
          //       context,
          //       'Chidamlilik',
          //       '3/5',
          //       Icons.directions_run,
          //     ),
          //     _buildAssessmentTile(
          //       context,
          //       'Moslashuvchanlik',
          //       '4/5',
          //       Icons.accessibility_new,
          //     ),
          //   ],
          // ),
          // _buildAssessmentSection(
          //   context,
          //   'Ruhiy holat',
          //   [
          //     _buildAssessmentTile(
          //       context,
          //       'Motivatsiya',
          //       '5/5',
          //       Icons.psychology,
          //     ),
          //     _buildAssessmentTile(
          //       context,
          //       'Kayfiyat',
          //       '4/5',
          //       Icons.mood,
          //     ),
          //     _buildAssessmentTile(
          //       context,
          //       'Stress darajasi',
          //       '2/5',
          //       Icons.self_improvement,
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 16),
          _buildHistorySection(context, dailyAssessments),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController dateController = TextEditingController();
    final TextEditingController strengthController = TextEditingController();
    final TextEditingController enduranceController = TextEditingController();
    final TextEditingController flexibilityController = TextEditingController();
    final TextEditingController motivationController = TextEditingController();
    final TextEditingController moodController = TextEditingController();
    final TextEditingController stressController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'O\'zingizni baholang ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    controller: dateController,
                    label: 'Sana (YYYY-MM-DD)',
                  ),
                  _buildCustomTextField(
                    controller: strengthController,
                    label: 'Kuch (masalan, 4/5)',
                  ),
                  _buildCustomTextField(
                    controller: enduranceController,
                    label: 'Chidamlilik (masalan, 3/5)',
                  ),
                  _buildCustomTextField(
                    controller: flexibilityController,
                    label: 'Moslashuvchanlik (masalan, 4/5)',
                  ),
                  _buildCustomTextField(
                    controller: motivationController,
                    label: 'Motivatsiya (masalan, 5/5)',
                  ),
                  _buildCustomTextField(
                    controller: moodController,
                    label: 'Kayfiyat (masalan, 4/5)',
                  ),
                  _buildCustomTextField(
                    controller: stressController,
                    label: 'Stress darajasi (masalan, 2/5)',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          dailyAssessments.add({
                            'date': dateController.text,
                            'physical': {
                              'Kuch': strengthController.text,
                              'Chidamlilik': enduranceController.text,
                              'Moslashuvchanlik': flexibilityController.text,
                            },
                            'mental': {
                              'Motivatsiya': motivationController.text,
                              'Kayfiyat': moodController.text,
                              'Stress darajasi': stressController.text,
                            },
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildAssessmentSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildAssessmentTile(
      BuildContext context, String title, String rating, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: Text(
          rating,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildHistorySection(
      BuildContext context, List<Map<String, dynamic>> dailyAssessments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Kunlik baholash tarixi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...dailyAssessments.map((assessment) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sana: ${assessment['date']}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const Divider(),
                  Text(
                    'Jismoniy holat:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  ...assessment['physical'].entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Text(
                    'Ruhiy holat:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  ...assessment['mental'].entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
