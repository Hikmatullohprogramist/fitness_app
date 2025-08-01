import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

/// Extension on String to easily get a video player widget from a video URL.
extension VideoUrlExtension on String {
  /// Returns a widget that plays the video at this URL using Chewie.
  Widget toVideoPlayerWidget({
    double? aspectRatio,
    bool autoPlay = false,
    bool looping = false,
    BoxFit fit = BoxFit.contain,
    Key? key,
  }) {
    print(this);
    return ChewieVideoPlayer(
      key: key,
      videoUrl: this,
      aspectRatio: aspectRatio,
      autoPlay: autoPlay,
      looping: looping,
      fit: fit,
    );
  }
}

/// A reusable video player widget for use in lists and dynamic layouts.
class ChewieVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double? aspectRatio;
  final bool autoPlay;
  final bool looping;
  final BoxFit fit;

  const ChewieVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.aspectRatio,
    this.autoPlay = false,
    this.looping = false,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  State<ChewieVideoPlayer> createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _copyErrorToClipboard() async {
    if (_errorMessage != null) {
      final errorDetails = '''
Video Error Details:
URL: ${widget.videoUrl}
Error: $_errorMessage
Time: ${DateTime.now()}
''';
      await Clipboard.setData(ClipboardData(text: errorDetails));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xato ma\'lumotlari nusxalandi'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _initPlayer() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      _videoController = VideoPlayerController.network(widget.videoUrl);
      await _videoController!.initialize();

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        aspectRatio: widget.aspectRatio ?? _videoController!.value.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        showControlsOnInitialize: false,
        allowPlaybackSpeedChanging: true,
        placeholder: Container(color: Colors.black),
        materialProgressColors: ChewieProgressColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,
        ),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Video yuklanmoqda...', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }
    if (_hasError || _chewieController == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  color: Theme.of(context).colorScheme.error, size: 48),
              const SizedBox(height: 8),
              Text(
                'Video yuklanmadi',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _initPlayer,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Qayta urinish',
                        style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_errorMessage != null)
                    ElevatedButton.icon(
                      onPressed: _copyErrorToClipboard,
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Nusxalash',
                          style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        backgroundColor: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return Chewie(
      controller: _chewieController!,
    );
  }
}
