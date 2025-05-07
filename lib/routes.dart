import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/exercises_screen.dart';
import 'screens/qr_exercises_screen.dart';
import 'screens/ideal_body_screen.dart';
import 'screens/physical_training_screen.dart';
import 'models/user.dart';
import 'models/workout.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String exercises = '/exercises';
  static const String activityQr = '/activity_qr';
  static const String idealBody = '/ideal_body';
  static const String physicalTraining = '/physical_training';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => HomeScreen(
              user: User(
                id: '1',
                name: 'Test User',
                email: 'test@example.com',
                profileImageUrl: '',
                birthDate: '1990-01-01',
                gender: 'Erkak',
                height: 175,
                weight: 70,
                phone: '+998901234567',
              ),
              recentWorkouts: [],
            ),
        profile: (context) => ProfileScreen(
              user: User(
                id: '1',
                name: 'Test User',
                email: 'test@example.com',
                profileImageUrl: '',
                birthDate: '1990-01-01',
                gender: 'Erkak',
                height: 175,
                weight: 70,
                phone: '+998901234567',
              ),
            ),
        exercises: (context) => const ExercisesScreen(),
        activityQr: (context) => const QRExercisesScreen(),
        idealBody: (context) => const IdealBodyScreen(),
        physicalTraining: (context) => const PhysicalTrainingScreen(),
      };
}
