import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import '../../../application/file_explorer/file_explorer_bloc.dart';
import '../../../application/file_explorer/file_explorer_event.dart';
import '../../../application/document/document_bloc.dart';
import '../../../application/document/document_event.dart';
import '../../../core/consts/supported_extensions.dart';
import '../../../domain/entities/file_node_entity.dart';

class FileTreeItem extends StatelessWidget {
  final FileNodeEntity node;
  final int depth;

  const FileTreeItem({super.key, required this.node, required this.depth});

  IconData _getFileIcon(String ext) {
    final type = SupportedExtensions.getType(ext);
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

  Color _getFileColor(String ext) {
    final type = SupportedExtensions.getType(ext);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () {
            if (node.isDirectory) {
              context.read<FileExplorerBloc>().add(ToggleDirectory(node.path));
            } else {
              context.read<DocumentBloc>().add(OpenDocument(node.path));
            }
          },
          child: Padding(
            padding: EdgeInsets.only(left: 12.0 + (depth * 16.0), right: 8, top: 3, bottom: 3),
            child: Row(
              children: [
                if (node.isDirectory)
                  Icon(
                    node.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    size: 16,
                    color: Colors.white38,
                  )
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 4),
                Icon(
                  node.isDirectory
                      ? (node.isExpanded ? Icons.folder_open : Icons.folder)
                      : _getFileIcon(p.extension(node.path)),
                  size: 16,
                  color: node.isDirectory
                      ? const Color(0xFFFFAB40)
                      : _getFileColor(p.extension(node.path)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    node.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: node.isDirectory ? Colors.white70 : Colors.white54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Children (expanded directories)
        if (node.isDirectory && node.isExpanded)
          ...node.children.map((child) => FileTreeItem(node: child, depth: depth + 1)),
      ],
    );
  }
}
