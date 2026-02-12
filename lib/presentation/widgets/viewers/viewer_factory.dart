import 'package:flutter/material.dart';
import '../../../core/consts/supported_extensions.dart';
import 'pdf_viewer_widget.dart';
import 'image_viewer_widget.dart';
import 'text_viewer_widget.dart';
import 'markdown_viewer_widget.dart';

/// Factory that returns the appropriate viewer widget based on document type.
class ViewerFactory {
  static Widget create({
    required DocumentType documentType,
    required String filePath,
    String? textContent,
    required double zoomLevel,
  }) {
    switch (documentType) {
      case DocumentType.pdf:
        return PdfViewerWidget(filePath: filePath, zoomLevel: zoomLevel);
      case DocumentType.image:
        return ImageViewerWidget(filePath: filePath, zoomLevel: zoomLevel);
      case DocumentType.text:
        return TextViewerWidget(
          content: textContent ?? '',
          filePath: filePath,
          zoomLevel: zoomLevel,
        );
      case DocumentType.markdown:
        return MarkdownViewerWidget(
          content: textContent ?? '',
          zoomLevel: zoomLevel,
        );
      case DocumentType.unknown:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.white38),
              SizedBox(height: 16),
              Text(
                'نوع الملف غير مدعوم',
                style: TextStyle(fontSize: 18, color: Colors.white54),
              ),
            ],
          ),
        );
    }
  }
}
