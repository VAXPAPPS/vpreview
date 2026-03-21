import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../../application/document/document_bloc.dart';
import '../../../application/document/document_event.dart';
import '../../../application/viewer_settings/viewer_settings_bloc.dart';
import '../../../application/viewer_settings/viewer_settings_event.dart';
import '../../../application/viewer_settings/viewer_settings_state.dart';
import '../../../application/search/search_bloc.dart';
import '../../../application/search/search_event.dart';
import '../../../core/consts/supported_extensions.dart';

class ViewerToolbar extends StatelessWidget {
  const ViewerToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerSettingsBloc, ViewerSettingsState>(
      builder: (context, settings) {
        return Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15),
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
          ),
          child: Row(
            children: [
              // Open file button
              _ToolbarButton(
                icon: Icons.folder_open,
                tooltip: 'فتح ملف (Ctrl+O)',
                onPressed: () => _openFile(context),
              ),
              _divider(),

              // Zoom controls
              _ToolbarButton(
                icon: Icons.zoom_out,
                tooltip: 'تصغير',
                onPressed: () => context.read<ViewerSettingsBloc>().add(const ZoomOut()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  settings.zoomPercentage,
                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                ),
              ),
              _ToolbarButton(
                icon: Icons.zoom_in,
                tooltip: 'تكبير',
                onPressed: () => context.read<ViewerSettingsBloc>().add(const ZoomIn()),
              ),
              _ToolbarButton(
                icon: Icons.fit_screen,
                tooltip: 'إعادة ضبط',
                onPressed: () => context.read<ViewerSettingsBloc>().add(const ResetZoom()),
              ),
              _divider(),

              // Page navigation (for PDFs)
              if (settings.totalPages > 1) ...[
                _ToolbarButton(
                  icon: Icons.navigate_before,
                  tooltip: 'الصفحة السابقة',
                  onPressed: settings.currentPage > 1
                    ? () => context.read<ViewerSettingsBloc>().add(GoToPage(settings.currentPage - 1))
                    : null,
                ),
                Text(
                  '${settings.currentPage} / ${settings.totalPages}',
                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                ),
                _ToolbarButton(
                  icon: Icons.navigate_next,
                  tooltip: 'الصفحة التالية',
                  onPressed: settings.currentPage < settings.totalPages
                    ? () => context.read<ViewerSettingsBloc>().add(GoToPage(settings.currentPage + 1))
                    : null,
                ),
                _divider(),
              ],

              const Spacer(),

              // Search
              _ToolbarButton(
                icon: Icons.search,
                tooltip: 'بحث (Ctrl+F)',
                onPressed: () => context.read<SearchBloc>().add(const ToggleSearchBar()),
              ),

              // Thumbnails toggle
              _ToolbarButton(
                icon: Icons.view_sidebar_outlined,
                tooltip: 'المصغرات',
                isActive: settings.showThumbnails,
                onPressed: () => context.read<ViewerSettingsBloc>().add(const ToggleThumbnails()),
              ),

              // Fullscreen
              _ToolbarButton(
                icon: settings.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                tooltip: settings.isFullScreen ? 'خروج من ملء الشاشة' : 'ملء الشاشة (F11)',
                onPressed: () => context.read<ViewerSettingsBloc>().add(const ToggleFullScreen()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(width: 1, height: 18, color: Colors.white.withValues(alpha: 0.08)),
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
}

class _ToolbarButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isActive;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.isActive = false,
  });

  @override
  State<_ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<_ToolbarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? Colors.white.withValues(alpha: 0.12)
                  : _isHovered
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: widget.onPressed == null
                  ? Colors.white12
                  : widget.isActive
                      ? Colors.white
                      : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
