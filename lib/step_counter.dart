import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ModernStepCounter extends StatefulWidget {
  const ModernStepCounter({super.key});

  @override
  State<ModernStepCounter> createState() => _ModernStepCounterState();
}

class _ModernStepCounterState extends State<ModernStepCounter> {
  Stream<StepCount>? _stepCountStream;
  int _steps = 0;
  int _dailyGoal = 10000;
  bool _notified = false;

  late FlutterLocalNotificationsPlugin _notifications;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _loadGoal();
    _initPedometer();
    requestStepPermission();
  }

  Future<void> requestStepPermission() async {
    if (await Permission.activityRecognition.isDenied) {
      await Permission.activityRecognition.request();
    }
  }

  /// 🔔 Local notifications init
  void _initNotifications() async {
    _notifications = FlutterLocalNotificationsPlugin();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _notifications.initialize(initSettings);

    // ✅ Android 13 va iOS uchun permission so‘raymiz
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // iOS ruxsat
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Android 13+ ruxsat
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'steps_channel',
      'Step Counter',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(0, title, body, details);
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen((event) {
      setState(() {
        _steps = event.steps;
      });

      if (_steps >= _dailyGoal && !_notified) {
        _showNotification("🎉 Congratulations!",
            "You’ve reached your daily goal of $_dailyGoal steps!");
        _notified = true;
      }
    }).onError((error) {
      debugPrint("Step counter error: $error");
    });
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyGoal = prefs.getInt("dailyGoal") ?? 10000;
    });
  }

  Future<void> _saveGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("dailyGoal", goal);
    setState(() {
      _dailyGoal = goal;
      _notified = false; // reset notification for new goal
    });
  }

  void _showGoalDialog() {
    final controller = TextEditingController(text: _dailyGoal.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sizning maqsadingiz ?"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Kunlik maqsadingizni kiriting",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Bekor qilish"),
            ),
            ElevatedButton(
              onPressed: () {
                final goal = int.tryParse(controller.text);
                if (goal != null && goal > 0) {
                  _saveGoal(goal);
                }
                Navigator.pop(context);
              },
              child: const Text("Saqlash"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_steps / _dailyGoal).clamp(0.0, 1.0);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/animations/walking.json",
                          width: 140),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$_steps',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$_dailyGoal qadam",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: LinearProgressIndicator(
                          value: value,
                          // strokeWidth: 16,
                          // strokeCap: StrokeCap.round,

                          backgroundColor: Colors.grey.shade200,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showGoalDialog,
            icon: const Icon(Icons.flag),
            label: const Text("Maqsadni belgilash"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
