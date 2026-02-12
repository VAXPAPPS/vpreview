import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../../application/viewer_settings/viewer_settings_bloc.dart';
import '../../../application/viewer_settings/viewer_settings_event.dart';

class PdfViewerWidget extends StatefulWidget {
  final String filePath;
  final double zoomLevel;

  const PdfViewerWidget({
    super.key,
    required this.filePath,
    required this.zoomLevel,
  });

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  PdfViewerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return PdfViewer.file(
      widget.filePath,
      controller: _controller,
      params: PdfViewerParams(
        enableTextSelection: true,
        maxScale: 5.0,
        minScale: 0.25,
        scrollByMouseWheel: 1.0,
        pageDropShadow: const BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: Offset(2, 2),
        ),
        pagePaintCallbacks: [
          // Add page number overlay
        ],
        viewerOverlayBuilder: (context, size, handleLinkTap) => [
          // Bottom page indicator
          PdfViewerScrollThumb(
            controller: _controller!,
            orientation: ScrollbarOrientation.right,
            thumbSize: const Size(40, 30),
            thumbBuilder: (context, thumbSize, pageNumber, controller) {
              // Update bloc with current page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && pageNumber != null) {
                  context.read<ViewerSettingsBloc>().add(GoToPage(pageNumber));
                }
              });
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '$pageNumber',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              );
            },
          ),
        ],
        onDocumentChanged: (document) {
          if (document != null && mounted) {
            context.read<ViewerSettingsBloc>().add(
              SetTotalPages(document.pages.length),
            );
          }
        },
      ),
    );
  }
}
