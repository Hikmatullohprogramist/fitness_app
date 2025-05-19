import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../services/upload_service.dart';

class UploadExercisesScreen extends StatefulWidget {
  const UploadExercisesScreen({Key? key}) : super(key: key);

  @override
  State<UploadExercisesScreen> createState() => _UploadExercisesScreenState();
}

class _UploadExercisesScreenState extends State<UploadExercisesScreen> {
  final _uploadService = UploadService(
    baseUrl: 'https://fitnes.bizsoft.uz',
  );

  bool _isUploading = false;
  String _status = '';
  double _progress = 0.0;

  Future<void> _uploadExercises() async {
    setState(() {
      _isUploading = true;
      _status = 'Yuklash boshlandi...';
      _progress = 0.0;
    });

    try {
      // Get the path to the mashqlar directory
      final mashqlarPath = 'mashqlar';

      final success = await _uploadService.uploadAllExercises(mashqlarPath);

      setState(() {
        _isUploading = false;
        _status = success
            ? 'Barcha mashqlar muvaffaqiyatli yuklandi!'
            : 'Yuklashda xatolik yuz berdi';
        _progress = success ? 1.0 : 0.0;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
        _status = 'Xatolik yuz berdi: $e';
        _progress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mashqlarni yuklash'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isUploading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _uploadExercises,
                child: const Text('Mashqlarni yuklash'),
              ),
            const SizedBox(height: 20),
            Text(_status),
            if (_progress > 0)
              LinearProgressIndicator(
                value: _progress,
              ),
          ],
        ),
      ),
    );
  }
}
