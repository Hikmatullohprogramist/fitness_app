import 'package:flutter/material.dart';

class TimeProgressBar extends StatelessWidget {
  final double usedTime;
  final double dailyTimeLimit;

  const TimeProgressBar({
    super.key,
    required this.usedTime,
    required this.dailyTimeLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kunlik vaqt limiti',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: usedTime / dailyTimeLimit,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Qolgan vaqt: ${(dailyTimeLimit - usedTime).toInt()} daqiqa',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
