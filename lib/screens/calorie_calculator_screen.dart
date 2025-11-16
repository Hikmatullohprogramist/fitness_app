import 'package:flutter/material.dart';
import '../services/calorie_service.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  const CalorieCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalorieCalculatorScreen> createState() =>
      _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _calorieService = CalorieService();

  final List<ExerciseInput> _exercises = [];
  final List<Map<String, dynamic>> _exerciseDetails = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mashq MET hisoblash"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildExerciseSection(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateMET,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Hisoblash",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              if (_exerciseDetails.isNotEmpty) _buildResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mashqlar",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _exercises.add(ExerciseInput(type: 'walking', duration: 30));
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Mashq qo'shish"),
            ),
            const SizedBox(height: 12),
            Column(
              children: _exercises.asMap().entries.map((entry) {
                int index = entry.key;
                ExerciseInput ex = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      // Mashq turi dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: ex.type,
                          decoration: const InputDecoration(
                            labelText: 'Mashq turi',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'walking', child: Text('Piyoda yurish')),
                            DropdownMenuItem(
                                value: 'jogging',
                                child: Text('Yugurish (sek)')),
                            DropdownMenuItem(
                                value: 'running',
                                child: Text('Yugurish (tez)')),
                            DropdownMenuItem(
                                value: 'cycling', child: Text('Velosiped')),
                            DropdownMenuItem(
                                value: 'swimming', child: Text('Suzish')),
                            DropdownMenuItem(
                                value: 'yoga', child: Text('Yoga')),
                            DropdownMenuItem(
                                value: 'boxing', child: Text('Boks')),
                          ],
                          onChanged: (val) {
                            setState(() {
                              ex.type = val!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Davomiylik input
                      Expanded(
                        child: TextFormField(
                          initialValue: ex.duration.toString(),
                          decoration: const InputDecoration(
                            labelText: "Daqiqa",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            ex.duration = double.tryParse(val) ?? 0;
                          },
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _exercises.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mashq MET qiymatlari",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ..._exerciseDetails.map((ex) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${ex['duration']} daqiqa ${ex['exercise']}"),
                      Text("MET: ${ex['met']}"),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _calculateMET() {
    _exerciseDetails.clear();
    for (var ex in _exercises) {
      var result = _calorieService.calculateExerciseCalories(
        weight: 70, // vazn shart emas, faqat MET qaytaramiz
        duration: ex.duration,
        exerciseType: ex.type,
      );
      _exerciseDetails.add({
        'exercise': ex.type,
        'duration': ex.duration,
        'met': result['met'],
      });
    }
    setState(() {});
  }
}

class ExerciseInput {
  String type;
  double duration;

  ExerciseInput({required this.type, required this.duration});
}
