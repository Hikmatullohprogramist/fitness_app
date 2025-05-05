import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _isWorkoutStarted = false;
  final int _currentExerciseIndex = 0;
  final int _remainingTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.type),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWorkoutInfo(),
              const SizedBox(height: 24),
              _buildExerciseList(),
              const SizedBox(height: 24),
              _buildStartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mashg\'ulot haqida',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Mashg\'ulot turi', widget.workout.type),
            _buildInfoRow('Mashg\'ulot vaqti', '${widget.workout.date} min'),
            _buildInfoRow('Kaloriya', '${widget.workout.caloriesBurned}'),
            _buildInfoRow('Murabbiy', widget.workout.type),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mashqlar ro\'yxati',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.workout.exercises.length,
          itemBuilder: (context, index) {
            final exercise = widget.workout.exercises[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(exercise.name),
                subtitle: Text(
                  '${exercise.sets} ta set • ${exercise.reps} ta takror',
                ),
                trailing: _isWorkoutStarted && index == _currentExerciseIndex
                    ? const Icon(Icons.play_arrow, color: Colors.green)
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isWorkoutStarted = !_isWorkoutStarted;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _isWorkoutStarted
              ? 'Mashg\'ulotni yakunlash'
              : 'Mashg\'ulotni boshlash',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
