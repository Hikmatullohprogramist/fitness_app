import 'package:fitness_app/services/exercise_stats_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/exercies_model.dart';
import 'package:lottie/lottie.dart';

class WorkoutInfoScreen extends StatefulWidget {
  final Exercise exercise;
  const WorkoutInfoScreen({super.key, required this.exercise});

  @override
  State<WorkoutInfoScreen> createState() => _WorkoutInfoScreenState();
}

class _WorkoutInfoScreenState extends State<WorkoutInfoScreen> {
  final ExerciseStatsService _exerciseStatsService = ExerciseStatsService();
  String rating = 'good';

  Widget _buildMediaWidget(String url, ThemeData theme,
      {double? height, double? width}) {
    final ext = url.split('.').last.toLowerCase();
    if (ext == 'json') {
      return Lottie.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: theme.colorScheme.surfaceVariant,
            child: Icon(
              Icons.fitness_center,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          );
        },
      );
    } else {
      return Image.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: theme.colorScheme.surfaceVariant,
            child: Icon(
              Icons.fitness_center,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildMediaWidget(
                  widget.exercise.media.first.originalUrl, Theme.of(context)),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(widget.exercise.name),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined),
                      const SizedBox(width: 8),
                      Text(
                        ((double.tryParse(widget.exercise.duration) ?? 0) * 60)
                            .round()
                            .toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.exercise.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // const SizedBox(height: 16),
                  // _buildExerciseList(context),
                  const SizedBox(height: 16),
                  // _buildBenefitsSection(context),
                  // const SizedBox(height: 16),
                  // _buildInstructionsSection(context),
                  // const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //do exercies

                        ///show rating dialog good, good, satisfactory, unsatisfactory
                        ///
                        showDialog(
                          context: context,
                          builder: (context) {
                            String selectedRating = 'good';
                            return AlertDialog(
                              title: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star_rate_rounded,
                                      color: Colors.amber),
                                  SizedBox(width: 8),
                                  Text(
                                    'Mashqni baholang',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              content:
                                  StatefulBuilder(builder: (context, setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RadioListTile(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.sentiment_satisfied,
                                              color: Colors.lightGreen),
                                          SizedBox(width: 8),
                                          Text('Yaxshi'),
                                        ],
                                      ),
                                      value: 'good',
                                      groupValue: selectedRating,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRating = value.toString();
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.sentiment_neutral,
                                              color: Colors.orange),
                                          SizedBox(width: 8),
                                          Text('Qoniqarli'),
                                        ],
                                      ),
                                      value: 'satisfactory',
                                      groupValue: selectedRating,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRating = value.toString();
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.sentiment_dissatisfied,
                                              color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Qoniqarsiz'),
                                        ],
                                      ),
                                      value: 'unsatisfactory',
                                      groupValue: selectedRating,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRating = value.toString();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }),
                              actions: [
                                TextButton.icon(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Bekor qilish'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final res =
                                        _exerciseStatsService.doExercise(
                                      exerciseId: widget.exercise.id,
                                      duration: (double.tryParse(
                                                  widget.exercise.duration ??
                                                      '0') ??
                                              0)
                                          .round(),
                                      repetitions: widget.exercise.count,
                                      distance: 100,
                                      rating: selectedRating,
                                    );

                                    print(res);
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text('Tasdiqlash'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Mashg\'ulotni boshlash'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mashqlar:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.fitness_center, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Mashq ${index + 1}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  '3x12',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foydalari:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Foyda ${index + 1}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ko\'rsatmalar:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ko\'rsatma ${index + 1}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
