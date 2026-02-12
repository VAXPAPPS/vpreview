import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import '../../application/document/document_bloc.dart';
import '../../application/document/document_event.dart';
import '../../application/recent_files/recent_files_bloc.dart';
import '../../application/recent_files/recent_files_event.dart';
import '../../application/recent_files/recent_files_state.dart';
import '../../application/file_explorer/file_explorer_bloc.dart';
import '../../application/file_explorer/file_explorer_event.dart';
import '../../core/consts/supported_extensions.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    context.read<RecentFilesBloc>().add(const LoadRecentFiles());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.description, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'VAXP Document Viewer',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'عارض المستندات الاحترافي',
              style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
            ),
            const SizedBox(height: 48),

            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionCard(
                  icon: Icons.file_open,
                  label: 'فتح ملف',
                  subtitle: 'Ctrl + O',
                  color: const Color(0xFF42A5F5),
                  onTap: () => _openFile(context),
                ),
                const SizedBox(width: 16),
                _ActionCard(
                  icon: Icons.folder_open,
                  label: 'فتح مجلد',
                  subtitle: 'تصفح الملفات',
                  color: const Color(0xFFFFAB40),
                  onTap: () => _openFolder(context),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Recent files
            BlocBuilder<RecentFilesBloc, RecentFilesState>(
              builder: (context, state) {
                if (state is! RecentFilesLoaded || state.files.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history, size: 16, color: Colors.white38),
                        const SizedBox(width: 8),
                        const Text(
                          'الملفات الأخيرة',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white54),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.read<RecentFilesBloc>().add(const ClearRecentFiles()),
                          child: const Text('مسح', style: TextStyle(fontSize: 11, color: Colors.white24)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 500,
                      child: Column(
                        children: state.files.take(8).map((filePath) {
                          final ext = p.extension(filePath).toLowerCase();
                          final type = SupportedExtensions.getType(ext);
                          return _RecentFileItem(
                            filePath: filePath,
                            documentType: type,
                            onTap: () => context.read<DocumentBloc>().add(OpenDocument(filePath)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 48),

            // Supported formats
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _FormatChip(label: 'PDF', color: const Color(0xFFEF5350)),
                _FormatChip(label: 'PNG/JPG', color: const Color(0xFF66BB6A)),
                _FormatChip(label: 'Markdown', color: const Color(0xFF42A5F5)),
                _FormatChip(label: 'TXT/Code', color: const Color(0xFFFFCA28)),
              ],
            ),
          ],
        ),
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

  Future<void> _openFolder(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null && context.mounted) {
      context.read<FileExplorerBloc>().add(LoadDirectory(result));
    }
  }
}

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 160,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _isHovered ? widget.color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? widget.color.withOpacity(0.4) : Colors.white.withOpacity(0.08),
            ),
            boxShadow: _isHovered ? [
              BoxShadow(color: widget.color.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 4)),
            ] : [],
          ),
          child: Column(
            children: [
              Icon(widget.icon, size: 32, color: widget.color),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentFileItem extends StatefulWidget {
  final String filePath;
  final DocumentType documentType;
  final VoidCallback onTap;

  const _RecentFileItem({
    required this.filePath,
    required this.documentType,
    required this.onTap,
  });

  @override
  State<_RecentFileItem> createState() => _RecentFileItemState();
}

class _RecentFileItemState extends State<_RecentFileItem> {
  bool _isHovered = false;

  IconData get _icon {
    switch (widget.documentType) {
      case DocumentType.pdf: return Icons.picture_as_pdf;
      case DocumentType.image: return Icons.image;
      case DocumentType.markdown: return Icons.article;
      case DocumentType.text: return Icons.code;
      case DocumentType.unknown: return Icons.insert_drive_file;
    }
  }

  Color get _color {
    switch (widget.documentType) {
      case DocumentType.pdf: return const Color(0xFFEF5350);
      case DocumentType.image: return const Color(0xFF66BB6A);
      case DocumentType.markdown: return const Color(0xFF42A5F5);
      case DocumentType.text: return const Color(0xFFFFCA28);
      case DocumentType.unknown: return Colors.white38;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(_icon, size: 16, color: _color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.basename(widget.filePath),
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      p.dirname(widget.filePath),
                      style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.3)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (_isHovered)
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  final String label;
  final Color color;

  const _FormatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
