import 'package:fitness_app/models/exercies_model.dart';
import 'package:flutter/material.dart';

class DamOlishTimer extends StatelessWidget {
  final Exercise exercise;
  const DamOlishTimer({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return exercise.name.contains("Juftlikda ") ||
            exercise.name.contains("Jamoaviy") ||
            exercise.vacationTime == 0
        ? Container()
        : Container(
            // width: 200,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 12,
              children: [
                Icon(
                  Icons.repeat,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  "Dam olish intervali: ${exercise.vacationTime ~/ 2} - ${exercise.vacationTime} soniya",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
  }
}
