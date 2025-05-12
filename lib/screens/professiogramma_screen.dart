import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessiogrammaScreen extends StatefulWidget {
  const ProfessiogrammaScreen({Key? key}) : super(key: key);

  @override
  State<ProfessiogrammaScreen> createState() => _ProfessiogrammaScreenState();
}

class _ProfessiogrammaScreenState extends State<ProfessiogrammaScreen> {
  late final WebViewController controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    final documentUrl =
        'https://fitnes.bizsoft.uz/storage/theory-materials/01JTJS0FA22NEN2ER5EVT50Z2P.docx';
    final googleDocsUrl =
        'https://docs.google.com/viewer?url=${Uri.encodeComponent(documentUrl)}&embedded=true';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
            _showError(error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(googleDocsUrl));
  }

  void _showError(String error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Xatolik yuz berdi: $error'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Qayta urinish',
          onPressed: () {
            setState(() {
              _hasError = false;
              _isLoading = true;
            });
            _initializeWebView();
          },
        ),
      ),
    );
  }

  Future<void> _openInBrowser() async {
    final documentUrl =
        'https://fitnes.bizsoft.uz/storage/theory-materials/01JTJS0FA22NEN2ER5EVT50Z2P.docx';
    final googleDocsUrl =
        'https://docs.google.com/viewer?url=${Uri.encodeComponent(documentUrl)}&embedded=true';

    if (await canLaunchUrl(Uri.parse(googleDocsUrl))) {
      await launchUrl(Uri.parse(googleDocsUrl),
          mode: LaunchMode.externalApplication);
    } else {
      _showError('Brauzerda ochib bo\'lmadi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professiogramma'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _openInBrowser,
            tooltip: 'Brauzerda ochish',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError) WebViewWidget(controller: controller),
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Dokumentni yuklab bo\'lmadi',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _isLoading = true;
                      });
                      _initializeWebView();
                    },
                    child: const Text('Qayta urinish'),
                  ),
                ],
              ),
            ),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Dokument yuklanmoqda...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
