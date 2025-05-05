
# Student Fitness Tracker App (Educational Purpose)

## 📱 App Overview
An offline-capable fitness tracker mobile app built for students to manually log workouts, assess themselves, learn fitness theory, and monitor physical development. This is intended for use in educational institutions as part of a scientific project.

---

## 🧱 App Architecture
**Clean Architecture** with separation of concerns:
- **Presentation Layer**: UI Widgets, GetX Controllers
- **Domain Layer**: UseCases, Entities (core logic)
- **Data Layer**: Hive or SQLite for local data persistence, Models, Repositories

---

## 🎨 UI Design
- **Color scheme**: Blue/Green for calm and healthy vibes
- **Typography**: Clean Sans-serif fonts
- **Navigation**: Drawer menu + BottomNavigation
- **Widgets**: Card, Container, FormFields, Sliders, Charts
- **Charts**: Bar or Line chart for progress tracking

---

## 📲 Screens

1. **Registration Screen**
   - Fields: Name, Age, Gender, Class, Height, Weight, Fitness Level
   - Auto-calculates BMI and shows user-suitable time schedule

2. **Home Screen**
   - Physical development level (table)
   - Career fitness standard (professiogramma)
   - Individual exercises
   - General fitness rating

3. **Drawer Menu Screens**
   - 📚 Theory
   - 💪 My Workouts
   - 🕒 Time Regulation
   - 🧠 Self-Evaluation
   - 📓 My Journal
   - 👤 My Profile

---

## 🔁 User Flow

1. Launch App → Registration screen
2. User fills in data → BMI calculated
3. Directed to Home screen
4. Manual workout logging and self-evaluation
5. Read theory, log progress in journal

---

## ✨ Features

- 🔐 User Registration (local)
- 📊 BMI Calculator
- 🔥 MET-based calorie tracker (manual input)
- 📚 Rich-text theory content
- 🧠 Self-assessment quizzes
- 📋 Workout Log (manual input)
- 🗓️ Time schedule by fitness level
- 📓 Progress Journal
- 📴 Full offline support (Hive or SQLite)
- 🧠 AI suggestions (optionally): Based on BMI and age

---

## 🧍 Data Models (Simplified)

```dart
class User {
  String name;
  int age;
  String gender;
  double height;
  double weight;
  String fitnessLevel;
  double get bmi => weight / (height * height);
}

class Workout {
  DateTime date;
  String type;
  int durationMinutes;
  double caloriesBurned;
}

class JournalEntry {
  DateTime date;
  String note;
}

class Evaluation {
  DateTime date;
  Map<String, bool> answers;
}
```

---

## ⚙️ Technologies

- **Flutter**
- **State Management**: GetX
- **Database**: Hive or SQLite
- **Charting**: fl_chart
- **Offline Mode**: Full support
- **No premium / subscription** model

---

📅 Generated: 2025-04-10
