import 'package:fitness_app/screens/workout_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/exercies_model.dart';
import '../widgets/media_widget.dart';

class SubCategoryExercisesScreen extends StatelessWidget {
  final String subCategoryName;
  final List<Exercise> exercises;
  final bool _isLoadingExercises;

  const SubCategoryExercisesScreen({
    Key? key,
    required this.subCategoryName,
    required this.exercises,
    required bool isLoadingExercises,
  })  : _isLoadingExercises = isLoadingExercises,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debug: Print the state when building
    print(
        'SubCategoryExercisesScreen build - Loading: $_isLoadingExercises, Exercises count: ${exercises.length}');

    return Scaffold(
      appBar: AppBar(
        title: Text(subCategoryName),
      ),
      body: _isLoadingExercises
          ? const Center(child: CircularProgressIndicator())
          : exercises.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center,
                          size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        "Mashqlar topilmadi",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Subkategoriya: $subCategoryName",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Debug info
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.yellow[100],
                      child: Text(
                        'DEBUG: ${exercises.length} ta mashq topildi',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          print('Rendering exercise $index: ${exercise.name}'); // Debug
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WorkoutInfoScreen(exercise: exercise),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                      if (exercise.media.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: MediaWidget(
                                          url: exercise.media[0].originalUrl,
                                          height: 200,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ],


                                    
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            exercise.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${(double.parse(exercise.duration) * 60).round()} soniya',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      exercise.description,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  
                                  ],
                                ),
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
}
