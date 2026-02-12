import 'package:equatable/equatable.dart';
import '../../core/consts/supported_extensions.dart';

/// Represents a document opened in the viewer.
class DocumentEntity extends Equatable {
  final String id;
  final String filePath;
  final String fileName;
  final String extension;
  final DocumentType documentType;
  final int fileSize;
  final DateTime lastModified;

  const DocumentEntity({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.extension,
    required this.documentType,
    required this.fileSize,
    required this.lastModified,
  });

  @override
  List<Object?> get props => [id, filePath, fileName, extension, documentType, fileSize, lastModified];
}
