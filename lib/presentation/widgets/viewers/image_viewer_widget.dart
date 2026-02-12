import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerWidget extends StatelessWidget {
  final String filePath;
  final double zoomLevel;

  const ImageViewerWidget({
    super.key,
    required this.filePath,
    required this.zoomLevel,
  });

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: FileImage(File(filePath)),
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      minScale: PhotoViewComputedScale.contained * 0.5,
      maxScale: PhotoViewComputedScale.covered * 3.0,
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(tag: filePath),
      loadingBuilder: (context, event) => Center(
        child: CircularProgressIndicator(
          value: event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          color: Colors.white38,
        ),
      ),
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image, size: 64, color: Colors.white38),
            SizedBox(height: 16),
            Text('فشل تحميل الصورة', style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
