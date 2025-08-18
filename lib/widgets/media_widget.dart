import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/video_extensions.dart';

class MediaWidget extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Color? backgroundColor;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const MediaWidget({
    Key? key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.autoPlay = false,
    this.looping = false,
    this.aspectRatio = 16 / 9,
    this.backgroundColor,
    this.errorWidget,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = url.split('.').last.toLowerCase();

    Widget buildWidget() {
      if (ext == 'json') {
        return Container(
          height: height,
          width: width,
          color: backgroundColor ?? theme.colorScheme.surfaceVariant,
          alignment: Alignment.center,
          child: Lottie.network(
            url,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ??
                  Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: theme.colorScheme.primary,
                  );
            },
          ),
        );
      } else if (['mp4', 'mov', 'webm', 'mkv'].contains(ext)) {
        return Container(
          height: height,
          width: width,
          color: backgroundColor ?? theme.colorScheme.surfaceVariant,
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: url.toVideoPlayerWidget(
              aspectRatio: aspectRatio,
              autoPlay: autoPlay,
              looping: looping,
            ),
          ),
        );
      } else {
        return Container(
          height: height,
          width: width,
          color: backgroundColor ?? theme.colorScheme.surfaceVariant,
          alignment: Alignment.center,
          child: Image.network(
            url,
            height: height,
            width: width,
            fit: fit,
            filterQuality: FilterQuality.high,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return loadingWidget ??
                  Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
            },
            errorBuilder: (context, error, stackTrace) {
              return errorWidget ??
                  Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: theme.colorScheme.primary,
                  );
            },
          ),
        );
      }
    }

    return SizedBox(
      height: height,
      width: width,
      child: buildWidget(),
    );
  }
}
