import '../models/calorie_calculation.dart';

class CalorieService {
  // Singleton pattern
  static final CalorieService _instance = CalorieService._internal();
  factory CalorieService() => _instance;
  CalorieService._internal();

  // Asosiy kaloriya hisoblash
  CalorieCalculation createCalculation({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  }) {
    return CalorieCalculation(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
    );
  }

  // Mashq uchun kaloriya yoqish hisoblash
  Map<String, double> calculateExerciseCalories({
    required double weight,
    required double duration, // daqiqada
    required String exerciseType,
  }) {
    // Har bir mashq turi uchun MET (Metabolic Equivalent of Task) qiymatlari
    Map<String, double> metValues = {
      'walking': 3.5,
      'jogging': 7.0,
      'running': 11.5,
      'cycling': 8.0,
      'swimming': 8.0,
      'weightlifting': 3.0,
      'yoga': 2.5,
      'pilates': 3.0,
      'dancing': 5.0,
      'basketball': 8.0,
      'football': 8.0,
      'tennis': 7.0,
      'boxing': 12.0,
      'kickboxing': 10.0,
      'hiit': 12.0,
      'strength_training': 4.0,
      'cardio': 8.0,
      'stretching': 2.0,
    };

    double met = metValues[exerciseType.toLowerCase()] ?? 5.0;

    // Kaloriya hisoblash formulasi: (MET × weight × duration) / 60
    double caloriesBurned = (met * weight * duration) / 60;

    return {
      'calories': caloriesBurned,
      'met': met,
      'duration': duration,
    };
  }

  // Kunlik faollik uchun kaloriya hisoblash
  double calculateDailyActivityCalories({
    required double weight,
    required Map<String, double> activities, // activity: duration
  }) {
    double totalCalories = 0;

    activities.forEach((activity, duration) {
      var result = calculateExerciseCalories(
        weight: weight,
        duration: duration,
        exerciseType: activity,
      );
      totalCalories += result['calories']!;
    });

    return totalCalories;
  }

  // Vazn yo'qotish uchun kunlik kaloriya defitsiti
  double calculateWeightLossDeficit({
    required double currentWeight,
    required double targetWeight,
    required int weeksToTarget,
  }) {
    double weightToLose = currentWeight - targetWeight;
    double weeklyDeficit = weightToLose * 7700; // 1 kg = 7700 kaloriya
    return weeklyDeficit / weeksToTarget;
  }

  // Vazn oshirish uchun kunlik kaloriya surplus
  double calculateWeightGainSurplus({
    required double currentWeight,
    required double targetWeight,
    required int weeksToTarget,
  }) {
    double weightToGain = targetWeight - currentWeight;
    double weeklySurplus = weightToGain * 7700; // 1 kg = 7700 kaloriya
    return weeklySurplus / weeksToTarget;
  }

  // Suv ehtiyoji hisoblash
  double calculateWaterIntake({
    required double weight,
    required double exerciseDuration, // kunlik mashq vaqti (daqiqada)
    required String climate, // 'normal', 'hot', 'cold'
  }) {
    // Asosiy suv ehtiyoji: 30ml per kg
    double baseWater = weight * 30;

    // Mashq uchun qo'shimcha suv: 350ml per hour
    double exerciseWater = (exerciseDuration / 60) * 350;

    // Iqlim uchun ko'paytiruvchi
    double climateMultiplier = 1.0;
    switch (climate.toLowerCase()) {
      case 'hot':
        climateMultiplier = 1.2;
        break;
      case 'cold':
        climateMultiplier = 0.9;
        break;
    }

    return (baseWater + exerciseWater) * climateMultiplier;
  }

  // Protein ehtiyoji hisoblash (mashq darajasiga qarab)
  double calculateProteinNeeds({
    required double weight,
    required String activityLevel,
    required String goal,
  }) {
    double baseProtein = weight * 0.8; // Minimal ehtiyoj

    // Faollik darajasiga qarab
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        baseProtein = weight * 1.0;
        break;
      case 'light':
        baseProtein = weight * 1.2;
        break;
      case 'moderate':
        baseProtein = weight * 1.6;
        break;
      case 'active':
        baseProtein = weight * 1.8;
        break;
      case 'very_active':
        baseProtein = weight * 2.0;
        break;
    }

    // Maqsadga qarab
    switch (goal.toLowerCase()) {
      case 'lose':
        baseProtein = weight * 2.2; // Vazn yo'qotishda ko'proq protein
        break;
      case 'gain':
        baseProtein = weight * 2.0; // Vazn oshirishda ko'proq protein
        break;
    }

    return baseProtein;
  }

  // Mashq intensivligi hisoblash
  String calculateExerciseIntensity({
    required double heartRate,
    required int age,
    required String fitnessLevel, // 'beginner', 'intermediate', 'advanced'
  }) {
    // Maksimal yurak urish tezligi hisoblash
    double maxHeartRate = (220 - age).toDouble();

    // Intensivlik foizi
    double intensityPercentage = (heartRate / maxHeartRate) * 100;

    if (intensityPercentage < 50) {
      return 'Very Light';
    } else if (intensityPercentage < 60) {
      return 'Light';
    } else if (intensityPercentage < 70) {
      return 'Moderate';
    } else if (intensityPercentage < 80) {
      return 'Vigorous';
    } else if (intensityPercentage < 90) {
      return 'High';
    } else {
      return 'Maximum';
    }
  }

  // Mashq samaradorligi hisoblash
  Map<String, dynamic> calculateWorkoutEfficiency({
    required double targetCalories,
    required double actualCalories,
    required double targetDuration,
    required double actualDuration,
    required int targetHeartRate,
    required int actualHeartRate,
  }) {
    double calorieEfficiency = (actualCalories / targetCalories) * 100;
    double durationEfficiency = (actualDuration / targetDuration) * 100;
    double heartRateEfficiency = (actualHeartRate / targetHeartRate) * 100;

    double overallEfficiency =
        (calorieEfficiency + durationEfficiency + heartRateEfficiency) / 3;

    String efficiencyGrade;
    if (overallEfficiency >= 90) {
      efficiencyGrade = 'A+';
    } else if (overallEfficiency >= 80) {
      efficiencyGrade = 'A';
    } else if (overallEfficiency >= 70) {
      efficiencyGrade = 'B';
    } else if (overallEfficiency >= 60) {
      efficiencyGrade = 'C';
    } else {
      efficiencyGrade = 'D';
    }

    return {
      'overallEfficiency': overallEfficiency,
      'grade': efficiencyGrade,
      'calorieEfficiency': calorieEfficiency,
      'durationEfficiency': durationEfficiency,
      'heartRateEfficiency': heartRateEfficiency,
    };
  }
}
