import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fitness_app/services/auth_service.dart';
import 'package:path/path.dart' as path;

class ExercisesService {
  static const String baseUrl = 'https://fitnes.bizsoft.uz/api';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getExercises() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/exersices'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get exercises');
      }
    } catch (e) {
      throw Exception('Error getting exercises: $e');
    }
  }

  Future<Map<String, dynamic>> getExercise(int id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/exercise/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get exercise');
      }
    } catch (e) {
      throw Exception('Error getting exercise: $e');
    }
  }

  Future<void> createExerciseFromJson(Map<String, dynamic> exerciseData) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token not found. Please login first.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/exersices'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(exerciseData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create exercise: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating exercise: $e');
    }
  }

  Future<void> uploadExercisesFromDirectory(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        throw Exception('Directory not found: $directoryPath');
      }

      final List<FileSystemEntity> files =
          await directory.list(recursive: true).toList();

      for (var file in files) {
        if (file is File && path.extension(file.path) == '.json') {
          final String content = await file.readAsString();
          final Map<String, dynamic> exerciseData = json.decode(content);

          // Prepare exercise data according to API requirements
          final Map<String, dynamic> apiData = {
            'name': exerciseData['name'] ?? '',
            'duration': exerciseData['duration'] ?? 0,
            'category_ids': exerciseData['category_ids'] ?? [],
            'count': exerciseData['count'],
            'description': exerciseData['description'],
            'vacation_time': exerciseData['vacation_time'],
            'media': exerciseData['media'] ?? [],
          };

          await createExerciseFromJson(apiData);
          print('Successfully uploaded exercise: ${exerciseData['name']}');
        }
      }
    } catch (e) {
      throw Exception('Error uploading exercises: $e');
    }
  }

  Future<void> createYogaExercises() async {
    final exercises = [
      {
        'name': 'Surya Namaskar (Quyosh salomi)',
        'duration': 300, // 5 daqiqa
        'category_ids': [1], // Yoga kategoriyasi
        'count': 5,
        'description':
            'Quyosh salomi - bu 12 ta asosiy yoga pozalaridan iborat mashq. Bu mashq tanani isinishga, mushaklarni cho\'zishga va energiyani oshirishga yordam beradi.',
        'vacation_time': 30,
        'media': ['yoga_surya.gif', 'yoga_surya.json'],
      },
      {
        'name': 'Tadasana (Daraxt pozi)',
        'duration': 180, // 3 daqiqa
        'category_ids': [1],
        'count': 1,
        'description':
            'Tadasana - bu asosiy yoga pozi. Bu poza muvozanatni, tuzilishni va tayanchni yaxshilaydi.',
        'vacation_time': 20,
        'media': ['yoga_tadasana.gif', 'yoga_tadasana.json'],
      },
      {
        'name': 'Vrikshasana (Daraxt pozi)',
        'duration': 240, // 4 daqiqa
        'category_ids': [1],
        'count': 3,
        'description':
            'Vrikshasana - bu muvozanatni yaxshilaydigan yoga pozi. Bu poza oyoqlarni kuchaytiradi va konzentratsiyani oshiradi.',
        'vacation_time': 30,
        'media': ['yoga_vrikshasana.gif', 'yoga_vrikshasana.json'],
      },
      {
        'name': 'Adho Mukha Svanasana (Pastga qaragan it pozi)',
        'duration': 300, // 5 daqiqa
        'category_ids': [1],
        'count': 5,
        'description':
            'Bu poza orqa mushaklarni cho\'zadi, yelkalarni kuchaytiradi va miyani tinchlantiradi.',
        'vacation_time': 30,
        'media': ['yoga_adho.gif', 'yoga_adho.json'],
      },
      {
        'name': 'Bhujangasana (Kobra pozi)',
        'duration': 240, // 4 daqiqa
        'category_ids': [1],
        'count': 5,
        'description':
            'Kobra pozi orqa mushaklarni kuchaytiradi, umurtqa pog\'onasini cho\'zadi va ko\'krak qafasini kengaytiradi.',
        'vacation_time': 20,
        'media': ['yoga_cobra.gif', 'yoga_cobra.json'],
      },
      {
        'name': 'Balasana (Bola pozi)',
        'duration': 180, // 3 daqiqa
        'category_ids': [1],
        'count': 1,
        'description':
            'Bola pozi - bu dam olish pozi. Bu poza tanani tinchlantiradi va stressni kamaytiradi.',
        'vacation_time': 30,
        'media': ['yoga_child.gif', 'yoga_child.json'],
      },
      {
        'name': 'Savasana (Jasad pozi)',
        'duration': 300, // 5 daqiqa
        'category_ids': [1],
        'count': 1,
        'description':
            'Savasana - bu yakunlovchi dam olish pozi. Bu poza tanani to\'liq tinchlantiradi va mashqdan keyingi regeneratsiyani ta\'minlaydi.',
        'vacation_time': 0,
        'media': ['yoga_savasana.gif', 'yoga_savasana.json'],
      }
    ];

    for (var exercise in exercises) {
      await createExerciseFromJson(exercise);
    }
  }

  Future<void> createShoulderExercises() async {
    final exercises = [
      {
        'name': 'Yelka bosish',
        'duration': 180, // 3 daqiqa
        'category_ids': [2], // Yelka kategoriyasi
        'count': 15,
        'description':
            'Yelka mushaklarini kuchaytiradigan asosiy mashq. Dumbbell yoki shlang yordamida amalga oshiriladi.',
        'vacation_time': 30,
        'media': ['shoulder_press.gif', 'shoulder_press.json'],
      },
      {
        'name': 'Yon tomonga ko\'tarish',
        'duration': 180,
        'category_ids': [2],
        'count': 12,
        'description':
            'Yelka mushaklarining yon qismini kuchaytiradigan mashq. Dumbbell yordamida amalga oshiriladi.',
        'vacation_time': 30,
        'media': ['lateral_raise.gif', 'lateral_raise.json'],
      },
      {
        'name': 'Old tomonga ko\'tarish',
        'duration': 180,
        'category_ids': [2],
        'count': 12,
        'description':
            'Yelka mushaklarining old qismini kuchaytiradigan mashq. Dumbbell yordamida amalga oshiriladi.',
        'vacation_time': 30,
        'media': ['front_raise.gif', 'front_raise.json'],
      },
      {
        'name': 'Orqaga tortish',
        'duration': 180,
        'category_ids': [2],
        'count': 12,
        'description':
            'Yelka mushaklarining orqa qismini kuchaytiradigan mashq. Shlang yordamida amalga oshiriladi.',
        'vacation_time': 30,
        'media': ['rear_delt.gif', 'rear_delt.json'],
      },
      {
        'name': 'Yelka aylanish',
        'duration': 240,
        'category_ids': [2],
        'count': 10,
        'description':
            'Yelka mushaklarini isinishga va cho\'zishga yordam beradigan mashq. Dumbbell yordamida amalga oshiriladi.',
        'vacation_time': 30,
        'media': ['shoulder_rotation.gif', 'shoulder_rotation.json'],
      }
    ];

    for (var exercise in exercises) {
      await createExerciseFromJson(exercise);
    }
  }

  Future<void> createAbdominalExercises() async {
    final exercises = [
      {
        'name': 'Kross-kranch',
        'duration': 240, // 4 daqiqa
        'category_ids': [3], // Qorin kategoriyasi
        'count': 20,
        'description':
            'Qorin mushaklarining yon qismini kuchaytiradigan mashq. O\'ng tirsakni chap tizzaga, chap tirsakni o\'ng tizzaga yetkazish.',
        'vacation_time': 30,
        'media': ['cross_crunch.gif', 'cross_crunch.json'],
      },
      {
        'name': 'Plank',
        'duration': 180,
        'category_ids': [3],
        'count': 3,
        'description':
            'Qorin va orqa mushaklarni kuchaytiradigan statik mashq. Tana to\'g\'ri chiziqda bo\'lishi kerak.',
        'vacation_time': 60,
        'media': ['plank.gif', 'plank.json'],
      },
      {
        'name': 'Qorin press',
        'duration': 240,
        'category_ids': [3],
        'count': 15,
        'description':
            'Qorin mushaklarining yuqori qismini kuchaytiradigan mashq. Orqa ustida yotib, tanani yuqoriga ko\'tarish.',
        'vacation_time': 30,
        'media': ['ab_press.gif', 'ab_press.json'],
      },
      {
        'name': 'Tizza ko\'tarish',
        'duration': 240,
        'category_ids': [3],
        'count': 15,
        'description':
            'Qorin mushaklarining pastki qismini kuchaytiradigan mashq. Orqa ustida yotib, tizzalarni ko\'krak qafasiga yetkazish.',
        'vacation_time': 30,
        'media': ['leg_raise.gif', 'leg_raise.json'],
      },
      {
        'name': 'Rus twist',
        'duration': 240,
        'category_ids': [3],
        'count': 20,
        'description':
            'Qorin mushaklarining yon qismini kuchaytiradigan mashq. O\'tirgan holda tanani o\'ng va chap tomonga burish.',
        'vacation_time': 30,
        'media': ['russian_twist.gif', 'russian_twist.json'],
      }
    ];

    for (var exercise in exercises) {
      await createExerciseFromJson(exercise);
    }
  }

  Future<void> createCardioExercises() async {
    final exercises = [
      {
        'name': 'Kardio mashqi 1',
        'duration': 600, // 10 daqiqa
        'category_ids': [4], // Kardio kategoriyasi
        'count': 1,
        'description': 'Yuqori intensivlikdagi kardio mashq',
        'vacation_time': 60,
        'media': ['cardio1.gif', 'cardio1.json'],
      },
      // Boshqa kardio mashqlari...
    ];

    for (var exercise in exercises) {
      await createExerciseFromJson(exercise);
    }
  }

  Future<void> createAllExercises() async {
    try {
      await createYogaExercises();
      await createShoulderExercises();
      await createAbdominalExercises();
      await createCardioExercises();
      print('Barcha mashqlar muvaffaqiyatli yuklandi');
    } catch (e) {
      print('Xatolik yuz berdi: $e');
      rethrow;
    }
  }
}
