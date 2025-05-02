import 'package:flutter/material.dart';

class WorkoutCategoryScreen extends StatefulWidget {
  const WorkoutCategoryScreen({super.key});

  @override
  State<WorkoutCategoryScreen> createState() => _WorkoutCategoryScreenState();
}

class _WorkoutCategoryScreenState extends State<WorkoutCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the primary color
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mashg\'ulot turlari'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Kuch mashg\'ulotlari'),
              Tab(text: 'Yurish'),
              Tab(text: 'Yugurish'),
              Tab(text: 'Velosiped'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            Center(child: Text('Kuch mashg\'ulotlari')),
            Center(child: Text('Yurish')),
            Center(child: Text('Yugurish')),
            Center(child: Text('Velosiped')),
          ],
        ),
      ),
    );
  }
}
