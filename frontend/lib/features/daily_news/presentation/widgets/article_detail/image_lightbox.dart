import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_design.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

/// Fullscreen lightbox for images with a dark background.
/// Supports pinch‑to‑zoom, vertical swipe to dismiss and an action to open the image in the browser to download it.
class ImageLightbox extends StatelessWidget {
  const ImageLightbox({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (context.mounted) Navigator.of(context).pop();
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 500) {
            if (context.mounted) Navigator.of(context).pop();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          color: AppDesign.surface,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image_outlined,
                      color: AppDesign.surface,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.download, color: AppDesign.surface, size: 24),
                    onPressed: () async {
                      final uri = Uri.tryParse(imageUrl);
                      if (uri == null) return;
                      try {
                        final launched = await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                        if (!launched && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open image URL.'),
                            ),
                          );
                        }
                      } on PlatformException catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('This action is not supported on this platform.'),
                            ),
                          );
                        }
                      }
                    },
                    tooltip: 'Open image in browser',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppDesign.surface, size: 28),
                    onPressed: () {
                      if (context.mounted) Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
