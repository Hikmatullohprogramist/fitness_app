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
    baseUrl: 'https://fitnes.bizsoft.uz', // Replace with your actual API URL
    token:
        '10|rrM2bQ344kLupApRVOUTBXN38zCtxJJ1Ky6Yp3nK9ec2a429', // Replace with your actual auth token
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isUploading)
              Column(
                children: [
                  CircularProgressIndicator(value: _progress),
                  const SizedBox(height: 16),
                  Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _uploadExercises,
                    child: const Text('Mashqlarni yuklashni boshlash'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
