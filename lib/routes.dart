import 'package:fitness_app/screens/main_screen.dart';
import 'package:fitness_app/screens/professiogramma_screen.dart';
import 'package:fitness_app/screens/pysical_development.dart';
import 'package:fitness_app/screens/upload_exercises_screen.dart';
import 'package:fitness_app/screens/physical_development_level_screen.dart';
import 'package:fitness_app/screens/workouts_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/exercises_screen.dart';
import 'screens/qr_exercises_screen.dart';
import 'screens/ideal_body_screen.dart';
import 'screens/physical_training_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'models/user.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String exercises = '/exercises';
  static const String activityQr = '/activity_qr';
  static const String idealBody = '/ideal_body';
  static const String physicalTraining = '/jismoniytk';
  static const String professiogramma = '/progress';
  static const String activityAnimatoin = '/activity_anim';
  static const String uploadExercises = '/upload_exercises';
  static const String physicalDevelopmentLevel = '/physical_development_level';
  static const String myExercises = '/my_exercises';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        main: (context) => const MainScreen(),
        register: (context) => const RegisterScreen(),
        home: (context) => HomeScreen(),
        profile: (context) => ProfileScreen(),
        exercises: (context) => const ExercisesScreen(),
        activityQr: (context) => const QRExercisesScreen(),
        idealBody: (context) => const IdealBodyScreen(),
        physicalTraining: (context) => PhysicalDevelopmentScreen(),
        professiogramma: (context) => const ProfessiogrammaScreen(),
        activityAnimatoin: (context) => const PhysicalTrainingScreen(),
        uploadExercises: (context) => const UploadExercisesScreen(),
        physicalDevelopmentLevel: (context) =>
            const PhysicalDevelopmentLevelScreen(),
        myExercises: (context) => const WorkoutsScreen(),
      };
}
