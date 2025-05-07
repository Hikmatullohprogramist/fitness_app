import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessiogrammaScreen extends StatefulWidget {
  const ProfessiogrammaScreen({Key? key}) : super(key: key);

  @override
  State<ProfessiogrammaScreen> createState() => _ProfessiogrammaScreenState();
}

class _ProfessiogrammaScreenState extends State<ProfessiogrammaScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _openDocument();
  }

  Future<void> _openDocument() async {
    try {
      // Replace this URL with your actual Word document URL
      final Uri url = Uri.parse('https://example.com/professiogramma.docx');

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dokumentni ochib bo\'lmadi'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xatolik yuz berdi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professiogramma'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Dokument ochilmoqda...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : const Text('Dokument ochildi'),
      ),
    );
  }
}
