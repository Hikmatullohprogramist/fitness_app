import 'package:flutter/material.dart';
import 'package:fitness_app/screens/workout_info_screen.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/workout_example.png'),
              ),
              title: Text('Mashg\'ulot ${index + 1}'),
              subtitle: const Text('45 daqiqa • Kuch mashqlari'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutInfoScreen(),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new workout functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
