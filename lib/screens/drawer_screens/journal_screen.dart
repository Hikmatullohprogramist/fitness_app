import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class ActivityEntry {
  String time;
  String activity;
  String duration;
  String intensity;
  String fitnessLevel;
  String id;

  ActivityEntry({
    required this.time,
    required this.activity,
    required this.duration,
    required this.intensity,
    required this.fitnessLevel,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'activity': activity,
      'duration': duration,
      'intensity': intensity,
      'fitnessLevel': fitnessLevel,
      'id': id,
    };
  }

  factory ActivityEntry.fromJson(Map<String, dynamic> json) {
    return ActivityEntry(
      time: json['time'] ?? '',
      activity: json['activity'] ?? '',
      duration: json['duration'] ?? '',
      intensity: json['intensity'] ?? 'O\'rta',
      fitnessLevel: json['fitnessLevel'] ?? 'Optimal',
      id: json['id'] ?? '',
    );
  }
}

class _JournalScreenState extends State<JournalScreen> {
  final List<String> weekdays = [
    'Dushanba',
    'Seshanba',
    'Chorshanba',
    'Payshanba',
    'Juma',
    'Shanba',
    'Yakshanba'
  ];

  final Map<String, Color> dayColors = {
    'Dushanba': Colors.blue.shade200,
    'Seshanba': Colors.green.shade200,
    'Chorshanba': Colors.red.shade200,
    'Payshanba': Colors.purple.shade200,
    'Juma': Colors.orange.shade200,
    'Shanba': Colors.teal.shade200,
    'Yakshanba': Colors.lime.shade200,
  };

  final List<String> intensityLevels = ['Past', 'O\'rta', 'Yuqori'];
  final List<String> fitnessLevels = ['Minimal', 'Optimal', 'Maximal'];
  final List<String> commonActivities = [
    'Piyoda yurish',
    'Yugurish',
    'Yoga mashqlari',
    'Kuch mashqlari',
    'Suzish',
    'Velosiped minish',
    'Tennis',
    'Futbol',
    'Basketbol',
    'Boshqa'
  ];

  int _selectedDayIndex = 0;
  Map<String, List<ActivityEntry>> dailyActivities = {};
  Map<String, String> dailyNotes = {};

  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDayIndex = now.weekday - 1;
    if (_selectedDayIndex > 6) _selectedDayIndex = 0;
    _loadData();
  }

  String get currentWeekKey {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return DateFormat('yyyy-MM-dd').format(weekStart);
  }

  String get selectedDayKey {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final selectedDate = weekStart.add(Duration(days: _selectedDayIndex));
    return DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load activities
    final activitiesJson =
        prefs.getString('journal_activities_$currentWeekKey');
    if (activitiesJson != null) {
      final Map<String, dynamic> data = json.decode(activitiesJson);
      setState(() {
        dailyActivities = data.map((key, value) => MapEntry(
              key,
              (value as List)
                  .map((item) => ActivityEntry.fromJson(item))
                  .toList(),
            ));
      });
    }

    // Load notes
    final notesJson = prefs.getString('journal_notes_$currentWeekKey');
    if (notesJson != null) {
      setState(() {
        dailyNotes = Map<String, String>.from(json.decode(notesJson));
      });
    }

    // Set current day's note
    _notesController.text = dailyNotes[selectedDayKey] ?? '';
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save activities
    final activitiesData = dailyActivities.map((key, value) =>
        MapEntry(key, value.map((entry) => entry.toJson()).toList()));
    await prefs.setString(
        'journal_activities_$currentWeekKey', json.encode(activitiesData));

    // Save notes
    await prefs.setString(
        'journal_notes_$currentWeekKey', json.encode(dailyNotes));
  }

  void _addActivity() {
    showDialog(
      context: context,
      builder: (context) => _ActivityDialog(
        onSave: (activity) {
          setState(() {
            final dayKey = selectedDayKey;
            if (!dailyActivities.containsKey(dayKey)) {
              dailyActivities[dayKey] = [];
            }
            dailyActivities[dayKey]!.add(activity);
          });
          _saveData();
        },
      ),
    );
  }

  void _editActivity(ActivityEntry activity) {
    showDialog(
      context: context,
      builder: (context) => _ActivityDialog(
        activity: activity,
        onSave: (updatedActivity) {
          setState(() {
            final dayKey = selectedDayKey;
            final activities = dailyActivities[dayKey] ?? [];
            final index = activities.indexWhere((a) => a.id == activity.id);
            if (index != -1) {
              activities[index] = updatedActivity;
            }
          });
          _saveData();
        },
        onDelete: () {
          setState(() {
            final dayKey = selectedDayKey;
            dailyActivities[dayKey]?.removeWhere((a) => a.id == activity.id);
          });
          _saveData();
        },
      ),
    );
  }

  void _saveNotes() {
    setState(() {
      dailyNotes[selectedDayKey] = _notesController.text;
    });
    _saveData();
  }

  bool get hasActivitiesForSelectedDay {
    final activities = dailyActivities[selectedDayKey];
    return activities != null && activities.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mening jurnalim'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addActivity,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDiaryHeader(),
          _buildDaySelector(),
          Expanded(
            child: _buildDayContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryHeader() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hafta: ${DateFormat('d MMM').format(weekStart)} - ${DateFormat('d MMM').format(weekEnd)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                'Oy: ${DateFormat('MMMM yyyy').format(now)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekdays.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedDayIndex;
          final now = DateTime.now();
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final dayDate = weekStart.add(Duration(days: index));
          final dayKey = DateFormat('yyyy-MM-dd').format(dayDate);
          final hasActivities = dailyActivities[dayKey]?.isNotEmpty ?? false;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDayIndex = index;
                  _notesController.text = dailyNotes[selectedDayKey] ?? '';
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? dayColors[weekdays[index]]
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: hasActivities
                        ? Colors.green.shade600
                        : (isSelected
                            ? Colors.transparent
                            : Colors.grey.shade300),
                    width: hasActivities ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        weekdays[index],
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayContent() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final selectedDate = weekStart.add(Duration(days: _selectedDayIndex));
    final dateStr = DateFormat('d MMM, yyyy').format(selectedDate);
    final activities = dailyActivities[selectedDayKey] ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: dayColors[weekdays[_selectedDayIndex]],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                '${weekdays[_selectedDayIndex]} - $dateStr',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: activities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hali mashqlar qo\'shilmagan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _addActivity,
                            icon: const Icon(Icons.add),
                            label: const Text('Mashq qo\'shish'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return _buildActivityEntry(activity);
                      },
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: _buildNotesSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityEntry(ActivityEntry activity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getIntensityColor(activity.intensity),
          child: Text(
            activity.time.split(':')[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          activity.activity,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Intensivlik: ${activity.intensity}'),
            Text('Daraja: ${activity.fitnessLevel}',
                style: TextStyle(
                  color: _getFitnessLevelColor(activity.fitnessLevel),
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              activity.duration,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              activity.time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        onTap: () => _editActivity(activity),
      ),
    );
  }

  Color _getIntensityColor(String intensity) {
    switch (intensity) {
      case 'Past':
        return Colors.green;
      case 'O\'rta':
        return Colors.orange;
      case 'Yuqori':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getFitnessLevelColor(String level) {
    switch (level) {
      case 'Minimal':
        return Colors.blue;
      case 'Optimal':
        return Colors.green;
      case 'Maximal':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: const Center(
            child: Text(
              'Eslatmalar:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Bu yerga eslatmalaringizni yozing...',
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
              ),
              onChanged: (value) => _saveNotes(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityDialog extends StatefulWidget {
  final ActivityEntry? activity;
  final Function(ActivityEntry) onSave;
  final VoidCallback? onDelete;

  const _ActivityDialog({
    this.activity,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<_ActivityDialog> createState() => _ActivityDialogState();
}

class _ActivityDialogState extends State<_ActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _timeController;
  late TextEditingController _activityController;
  late TextEditingController _durationController;
  late String _selectedIntensity;
  late String _selectedFitnessLevel;

  final List<String> intensityLevels = ['Past', 'O\'rta', 'Yuqori'];
  final List<String> fitnessLevels = ['Minimal', 'Optimal', 'Maximal'];
  final List<String> commonActivities = [
    'Piyoda yurish',
    'Yugurish',
    'Yoga mashqlari',
    'Kuch mashqlari',
    'Suzish',
    'Velosiped minish',
    'Tennis',
    'Futbol',
    'Basketbol',
    'Boshqa'
  ];

  @override
  void initState() {
    super.initState();
    // Format time without using context
    final now = TimeOfDay.now();
    final defaultTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    _timeController = TextEditingController(
      text: widget.activity?.time ?? defaultTime,
    );
    _activityController = TextEditingController(
      text: widget.activity?.activity ?? '',
    );
    _durationController = TextEditingController(
      text: widget.activity?.duration ?? '',
    );
    _selectedIntensity = widget.activity?.intensity ?? 'O\'rta';
    _selectedFitnessLevel = widget.activity?.fitnessLevel ?? 'Optimal';
  }

  @override
  void dispose() {
    _timeController.dispose();
    _activityController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _timeController.text = time.format(context);
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final activity = ActivityEntry(
        id: widget.activity?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        time: _timeController.text,
        activity: _activityController.text,
        duration: _durationController.text,
        intensity: _selectedIntensity,
        fitnessLevel: _selectedFitnessLevel,
      );
      widget.onSave(activity);
      Navigator.of(context).pop();
    }
  }

  Color _getFitnessLevelColor(String level) {
    switch (level) {
      case 'Minimal':
        return Colors.blue;
      case 'Optimal':
        return Colors.green;
      case 'Maximal':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.activity == null
          ? 'Yangi mashq qo\'shish'
          : 'Mashqni tahrirlash'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Vaqt',
                  prefixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: _selectTime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vaqtni tanlang';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: commonActivities.contains(_activityController.text)
                    ? _activityController.text
                    : 'Boshqa',
                decoration: const InputDecoration(
                  labelText: 'Mashq turi',
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                items: commonActivities.map((activity) {
                  return DropdownMenuItem(
                    value: activity,
                    child: Text(activity),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != 'Boshqa') {
                    _activityController.text = value!;
                  }
                },
              ),
              const SizedBox(height: 16),
              if (!commonActivities.contains(_activityController.text) ||
                  _activityController.text.isEmpty)
                TextFormField(
                  controller: _activityController,
                  decoration: const InputDecoration(
                    labelText: 'Mashq nomi',
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mashq nomini kiriting';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Davomiyligi (daqiqa)',
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Davomiylikni kiriting';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIntensity,
                decoration: const InputDecoration(
                  labelText: 'Intensivlik',
                  prefixIcon: Icon(Icons.show_chart),
                ),
                items: intensityLevels.map((intensity) {
                  return DropdownMenuItem(
                    value: intensity,
                    child: Text(intensity),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIntensity = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFitnessLevel,
                decoration: const InputDecoration(
                  labelText: 'Jismoniy tayyorgarlik darajasi',
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                items: fitnessLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getFitnessLevelColor(level),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(level),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFitnessLevel = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('O\'chirish'),
                  content: const Text(
                      'Haqiqatan ham bu mashqni o\'chirmoqchimisiz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Bekor qilish'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onDelete!();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('O\'chirish'),
                    ),
                  ],
                ),
              );
            },
            child:
                const Text('O\'chirish', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Bekor qilish'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Saqlash'),
        ),
      ],
    );
  }
}
