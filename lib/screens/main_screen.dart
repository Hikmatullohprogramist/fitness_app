import 'package:flutter/material.dart';
import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/screens/workouts_screen.dart';
import 'package:fitness_app/screens/statistics_screen.dart';
import 'package:fitness_app/screens/profile_screen.dart';
import 'package:fitness_app/widgets/app_drawer.dart';
import 'package:fitness_app/models/user.dart';

import '../models/workout.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(
      user: User(
        id: '1',
        name: 'Foydalanuvchi',
        email: 'user@example.com',
        profileImageUrl: 'https://example.com/profile.jpg',
        birthDate: '1990-01-01',
        gender: 'Erkak',
        height: 175,
        weight: 70,
        phone: '+998901234567',
      ),
      recentWorkouts: [
        Workout(
          type: "Kuch mashg\'ulot",
          durationMinutes: 45,
          notes: "Yuqori kuch",
          exercises: [
            Exercise(
              name: 'Bench Press',
              sets: 3,
              reps: 10,
              weight: 70.0,
              notes: 'Yaxshi his qildim',
            ),
            Exercise(
              name: 'Squats',
              sets: 4,
              reps: 12,
              weight: 80.0,
            ),
          ],
          caloriesBurned: 500,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
    const WorkoutsScreen(),
    // StatisticsScreen(workouts: []),
    ProfileScreen(
      user: User(
        id: '1',
        name: 'Foydalanuvchi',
        email: 'user@example.com',
        profileImageUrl: 'https://example.com/profile.jpg',
        birthDate: '1990-01-01',
        gender: 'Erkak',
        height: 175,
        weight: 70,
        phone: '+998901234567',
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness App"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Show notifications
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Asosiy'),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Mashqlar',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.assessment),
          //   label: 'Statistika',
          // ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
