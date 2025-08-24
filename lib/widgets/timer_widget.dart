import 'package:fitness_app/models/exercies_model.dart';
import 'package:flutter/material.dart';

String _roundToDurationBucket(int seconds) {
  if (seconds >= 40 && seconds < 45) return "40 soniya";
  if (seconds >= 45 && seconds < 50) return "45 soniya";
  if (seconds >= 50 && seconds < 55) return "50 soniya";

  // 55 dan 60 gacha -> 1 daqiqa
  if (seconds >= 55 && seconds <= 60) return "1 daqiqa";

  if (seconds > 60) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (remainingSeconds == 0) {
      return "$minutes daqiqa"; // ✅ faqat daqiqa yoziladi
    } else {
      return "$minutes daqiqa $remainingSeconds soniya";
    }
  }

  return "$seconds soniya";
}

class TimerWidget extends StatelessWidget {
  final Exercise exercise;
  const TimerWidget({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: exercise.name.contains("Yengil yugurish") ||
              exercise.name.contains("Tez sur'atda yurish")
          ? Container()
          : Text(
              _roundToDurationBucket(
                  (double.parse(exercise.duration) * 60).round()),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
