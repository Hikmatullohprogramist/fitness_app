import 'package:fitness_app/models/normalize.dart';
import 'package:fitness_app/services/exercises_service.dart';
import 'package:flutter/material.dart';

class MetCalculatorScreen extends StatefulWidget {
  @override
  _MetCalculatorScreenState createState() => _MetCalculatorScreenState();
}

class _MetCalculatorScreenState extends State<MetCalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  ExercisesService service = ExercisesService();

  // API dan keladigan mashqlar
  List<String> exerciseOptions = [];

  // Mashqlar ro‘yxati (foydalanuvchi tanlagan)
  List<ExerciseInput> exercises = [];

  double? totalCalories;
  bool isLoading = false;

  /// API dan mashqlarni olish
  Future<void> _fetchExercises() async {
    setState(() => isLoading = true);
    try {
      final data = await service.getExercises(page: 1, perPage: 50);
      final List exList = data['exercises'];

      // nomlarni normalize qilib olish
      setState(() {
        exerciseOptions = exList.map((e) {
          final name = e.name ?? "";
          final desc = e.description ?? "";
          return "$name";
        }).toList();
      });
    } catch (e) {
      debugPrint("Error fetching exercises: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Kaloriya hisoblash
  void calculateCalories() {
    if (_weightController.text.isEmpty || exercises.isEmpty) return;

    final double weight = double.tryParse(_weightController.text) ?? 0;
    double total = 0;

    for (var ex in exercises) {
      // MET qiymat olish (nom yoki description orqali)
      final double met = getMetValue(ex.type);
      final double hours = ex.duration / 60.0;
      total += met * weight * hours;
    }

    setState(() {
      totalCalories = total;
    });
  }

  /// MET qiymatini topish (normalize.dart dan foydalanib)
  double getMetValue(String text) {
    final normalized = normalize(text); // nomi + description normalize
    for (var key in metKeywords.keys) {
      if (normalized.contains(key)) {
        return metKeywords[key]!;
      }
    }
    return 3.0; // default
  }

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MET Kalkulyator"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Vazn
                  TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: "Tana vazni (kg)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Mashqlar qo'shish tugmasi
                  ElevatedButton.icon(
                    onPressed: () {
                      if (exerciseOptions.isNotEmpty) {
                        setState(() {
                          exercises.add(ExerciseInput(
                              type: exerciseOptions.first, duration: 30));
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Mashq qo'shish"),
                  ),
                  const SizedBox(height: 16),

                  // Mashqlar ro‘yxati
                  Column(
                    children: exercises.asMap().entries.map((entry) {
                      int index = entry.key;
                      ExerciseInput ex = entry.value;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Mashq turi (Dropdown)
                              Expanded(
                                flex: 5,
                                child: DropdownButtonFormField<String>(
                                  value: ex.type,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Mashq turi',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                  ),
                                  items: exerciseOptions
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      ex.type = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Davomiylik
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  initialValue: ex.duration.toString(),
                                  decoration: const InputDecoration(
                                    labelText: "Daqiqa",
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    ex.duration = double.tryParse(val) ?? 0;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),

                              // O‘chirish
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    exercises.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Hisoblash tugmasi
                  ElevatedButton(
                    onPressed: calculateCalories,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Hisoblash",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Natija
                  if (totalCalories != null)
                    Column(
                      children: [
                        Text(
                          "Umumiy yoqilgan kaloriyalar:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${totalCalories!.toStringAsFixed(2)} kcal",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}

class ExerciseInput {
  String type;
  double duration;

  ExerciseInput({required this.type, required this.duration});
}
