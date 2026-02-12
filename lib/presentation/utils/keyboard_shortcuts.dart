import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../application/document/document_bloc.dart';
import '../../application/document/document_event.dart';
import '../../application/document/document_state.dart';
import '../../application/search/search_bloc.dart';
import '../../application/search/search_event.dart';
import '../../application/viewer_settings/viewer_settings_bloc.dart';
import '../../application/viewer_settings/viewer_settings_event.dart';
import '../../core/consts/supported_extensions.dart';

/// Global keyboard shortcut handler for the Document Viewer.
class KeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const KeyboardShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        // Ctrl+O: Open file
        const SingleActivator(LogicalKeyboardKey.keyO, control: true): () => _openFile(context),
        // Ctrl+W: Close current tab
        const SingleActivator(LogicalKeyboardKey.keyW, control: true): () => _closeCurrentTab(context),
        // Ctrl+F: Toggle search
        const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
            context.read<SearchBloc>().add(const ToggleSearchBar()),
        // Ctrl+=: Zoom in
        const SingleActivator(LogicalKeyboardKey.equal, control: true): () =>
            context.read<ViewerSettingsBloc>().add(const ZoomIn()),
        // Ctrl+-: Zoom out
        const SingleActivator(LogicalKeyboardKey.minus, control: true): () =>
            context.read<ViewerSettingsBloc>().add(const ZoomOut()),
        // Ctrl+0: Reset zoom
        const SingleActivator(LogicalKeyboardKey.digit0, control: true): () =>
            context.read<ViewerSettingsBloc>().add(const ResetZoom()),
        // F11: Toggle fullscreen
        const SingleActivator(LogicalKeyboardKey.f11): () =>
            context.read<ViewerSettingsBloc>().add(const ToggleFullScreen()),
        // Escape: Close search
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.read<SearchBloc>().add(const ClearSearch()),
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }

  Future<void> _openFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: SupportedExtensions.all.map((e) => e.replaceFirst('.', '')).toList(),
    );
    if (result != null && result.files.single.path != null) {
      if (context.mounted) {
        context.read<DocumentBloc>().add(OpenDocument(result.files.single.path!));
      }
    }
  }

  void _closeCurrentTab(BuildContext context) {
    final state = context.read<DocumentBloc>().state;
    if (state is DocumentLoaded) {
      context.read<DocumentBloc>().add(CloseDocument(state.activeDocumentPath));
    }
  }
}
