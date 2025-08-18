class CalorieCalculation {
  final double weight; // kg
  final double height; // cm
  final int age;
  final String gender; // 'male' or 'female'
  final String activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  final String goal; // 'lose', 'maintain', 'gain'

  CalorieCalculation({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.goal,
  });

  // BMR (Basal Metabolic Rate) hisoblash - Harris-Benedict formulasi
  double calculateBMR() {
    if (gender.toLowerCase() == 'male') {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  // Activity multiplier hisoblash
  double getActivityMultiplier() {
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        return 1.2; // Little or no exercise
      case 'light':
        return 1.375; // Light exercise/sports 1-3 days/week
      case 'moderate':
        return 1.55; // Moderate exercise/sports 3-5 days/week
      case 'active':
        return 1.725; // Hard exercise/sports 6-7 days a week
      case 'very_active':
        return 1.9; // Very hard exercise/sports & physical job
      default:
        return 1.2;
    }
  }

  // Kunlik kaloriya ehtiyoji
  double calculateDailyCalories() {
    double bmr = calculateBMR();
    double tdee = bmr * getActivityMultiplier();
    
    switch (goal.toLowerCase()) {
      case 'lose':
        return tdee - 500; // 0.5 kg haftasiga yo'qotish uchun
      case 'gain':
        return tdee + 300; // 0.3 kg haftasiga oshirish uchun
      case 'maintain':
      default:
        return tdee;
    }
  }

  // Makro nutrientlar hisoblash
  Map<String, double> calculateMacros() {
    double dailyCalories = calculateDailyCalories();
    
    // Protein: 2.2g per kg body weight
    double proteinGrams = weight * 2.2;
    double proteinCalories = proteinGrams * 4;
    
    // Fat: 25% of total calories
    double fatCalories = dailyCalories * 0.25;
    double fatGrams = fatCalories / 9;
    
    // Carbohydrates: remaining calories
    double carbCalories = dailyCalories - proteinCalories - fatCalories;
    double carbGrams = carbCalories / 4;
    
    return {
      'protein': proteinGrams,
      'fat': fatGrams,
      'carbs': carbGrams,
      'proteinCalories': proteinCalories,
      'fatCalories': fatCalories,
      'carbCalories': carbCalories,
    };
  }

  // BMI hisoblash
  double calculateBMI() {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  // BMI kategoriyasi
  String getBMICategory() {
    double bmi = calculateBMI();
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal weight';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  // Ideal vazn hisoblash
  double calculateIdealWeight() {
    if (gender.toLowerCase() == 'male') {
      return 50 + 2.3 * ((height - 152.4) / 2.54);
    } else {
      return 45.5 + 2.3 * ((height - 152.4) / 2.54);
    }
  }

  // Vazn yo'qotish uchun kunlik kaloriya
  double calculateWeightLossCalories() {
    double tdee = calculateBMR() * getActivityMultiplier();
    return tdee - 500; // 0.5 kg haftasiga
  }

  // Vazn oshirish uchun kunlik kaloriya
  double calculateWeightGainCalories() {
    double tdee = calculateBMR() * getActivityMultiplier();
    return tdee + 300; // 0.3 kg haftasiga
  }
}
