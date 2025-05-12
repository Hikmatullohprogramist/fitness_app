import 'package:fitness_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'widgets/app_drawer.dart';
import 'widgets/menu_card.dart';
import 'widgets/time_progress_bar.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: optiFormaTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final double _dailyTimeLimit = 25; // in minutes
  final double _usedTime = 0; // Track used time

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness App"),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: Column(
        children: [
          TimeProgressBar(usedTime: _usedTime, dailyTimeLimit: _dailyTimeLimit),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                MenuCard(
                  icon: Icons.show_chart,
                  title: 'Jismoniy rivojlanish darajasi',
                  subtitle: 'Kunlik progress',
                  onTap: () => _navigateToSection(0),
                ),
                MenuCard(
                  icon: Icons.school,
                  title: 'Professiogramma',
                  subtitle: 'Kasbiy mezonlar',
                  onTap: () => _navigateToSection(1),
                ),
                MenuCard(
                  icon: Icons.fitness_center,
                  title: 'Individual mashg\'ulotlar',
                  subtitle: 'Mashqlar ro\'yxati',
                  onTap: () => _navigateToSection(2),
                ),
                MenuCard(
                  icon: Icons.track_changes,
                  title: 'Jismoniy tayyorgarlik',
                  subtitle: 'Joriy daraja',
                  onTap: () => _navigateToSection(3),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Asosiy'),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Mashqlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment),
            label: 'Statistika',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  void _navigateToSection(int index) {
    // Navigate to respective sections
  }
}
