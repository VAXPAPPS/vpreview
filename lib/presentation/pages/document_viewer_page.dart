import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../application/document/document_bloc.dart';
import '../../application/document/document_event.dart';
import '../../application/document/document_state.dart';
import '../../application/viewer_settings/viewer_settings_bloc.dart';
import '../../application/viewer_settings/viewer_settings_state.dart';
import '../../core/consts/supported_extensions.dart';
import '../widgets/sidebar/file_explorer_sidebar.dart';
import '../widgets/tabs/document_tab_bar.dart';
import '../widgets/toolbar/viewer_toolbar.dart';
import '../widgets/search/search_bar_widget.dart';
import '../widgets/viewers/viewer_factory.dart';
import '../utils/keyboard_shortcuts.dart';
import 'welcome_page.dart';

class DocumentViewerPage extends StatefulWidget {
  const DocumentViewerPage({super.key});

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcuts(
      child: DropTarget(
        onDragEntered: (_) => setState(() => _isDragging = true),
        onDragExited: (_) => setState(() => _isDragging = false),
        onDragDone: (details) {
          setState(() => _isDragging = false);
          for (final file in details.files) {
            final ext = file.path.split('.').last;
            if (SupportedExtensions.isSupported('.$ext')) {
              context.read<DocumentBloc>().add(OpenDocument(file.path));
            }
          }
        },
        child: Stack(
          children: [
            Row(
              children: [
                // Sidebar
                const FileExplorerSidebar(),

                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      // Tab bar
                      const DocumentTabBar(),

                      // Toolbar
                      const ViewerToolbar(),

                      // Search bar
                      BlocBuilder<DocumentBloc, DocumentState>(
                        builder: (context, state) {
                          String? content;
                          if (state is DocumentLoaded) {
                            content = state.textContents[state.activeDocumentPath];
                          }
                          return SearchBarWidget(currentContent: content);
                        },
                      ),

                      // Document viewer area
                      Expanded(
                        child: BlocBuilder<DocumentBloc, DocumentState>(
                          builder: (context, docState) {
                            if (docState is DocumentInitial) {
                              return const WelcomePage();
                            }

                            if (docState is DocumentLoading) {
                              return const Center(
                                child: CircularProgressIndicator(color: Colors.white24),
                              );
                            }

                            if (docState is DocumentError) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                                    const SizedBox(height: 16),
                                    Text(
                                      docState.message,
                                      style: const TextStyle(color: Colors.white54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (docState is DocumentLoaded) {
                              final activeDoc = docState.openDocuments.firstWhere(
                                (d) => d.filePath == docState.activeDocumentPath,
                              );

                              return BlocBuilder<ViewerSettingsBloc, ViewerSettingsState>(
                                builder: (context, settings) {
                                  return ViewerFactory.create(
                                    documentType: activeDoc.documentType,
                                    filePath: activeDoc.filePath,
                                    textContent: docState.textContents[activeDoc.filePath],
                                    zoomLevel: settings.zoomLevel,
                                  );
                                },
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Drag overlay
            if (_isDragging)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF667EEA), width: 2),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.file_download, size: 48, color: Color(0xFF667EEA)),
                          SizedBox(height: 16),
                          Text(
                            'Drop file here to open',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
