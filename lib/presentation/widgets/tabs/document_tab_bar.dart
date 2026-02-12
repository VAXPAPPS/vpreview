import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/document/document_bloc.dart';
import '../../../application/document/document_event.dart';
import '../../../application/document/document_state.dart';
import '../../../core/consts/supported_extensions.dart';

class DocumentTabBar extends StatelessWidget {
  const DocumentTabBar({super.key});

  Color _getTabColor(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return const Color(0xFFEF5350);
      case DocumentType.image:
        return const Color(0xFF66BB6A);
      case DocumentType.markdown:
        return const Color(0xFF42A5F5);
      case DocumentType.text:
        return const Color(0xFFFFCA28);
      case DocumentType.unknown:
        return Colors.white38;
    }
  }

  IconData _getTabIcon(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return Icons.picture_as_pdf;
      case DocumentType.image:
        return Icons.image;
      case DocumentType.markdown:
        return Icons.article;
      case DocumentType.text:
        return Icons.code;
      case DocumentType.unknown:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        if (state is! DocumentLoaded) return const SizedBox.shrink();

        return Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.openDocuments.length,
            itemBuilder: (context, index) {
              final doc = state.openDocuments[index];
              final isActive = doc.filePath == state.activeDocumentPath;

              return GestureDetector(
                onTap: () => context.read<DocumentBloc>().add(SwitchTab(doc.filePath)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white.withOpacity(0.08) : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: isActive ? _getTabColor(doc.documentType) : Colors.transparent,
                        width: 2,
                      ),
                      right: BorderSide(color: Colors.white.withOpacity(0.04)),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getTabIcon(doc.documentType),
                        size: 14,
                        color: _getTabColor(doc.documentType),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          doc.fileName,
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive ? Colors.white : Colors.white54,
                            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => context.read<DocumentBloc>().add(CloseDocument(doc.filePath)),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            Icons.close,
                            size: 12,
                            color: isActive ? Colors.white54 : Colors.white24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
