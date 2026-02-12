import 'dart:io';
import 'package:path/path.dart' as p;
import '../../core/consts/supported_extensions.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../../infrastructure/file_system_service.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final FileSystemService _fileSystemService;

  DocumentRepositoryImpl(this._fileSystemService);

  @override
  Future<DocumentEntity> loadDocument(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }

    final stat = await _fileSystemService.getFileStat(filePath);
    final ext = p.extension(filePath).toLowerCase();
    final fileName = p.basename(filePath);

    return DocumentEntity(
      id: filePath.hashCode.toRadixString(36),
      filePath: filePath,
      fileName: fileName,
      extension: ext,
      documentType: SupportedExtensions.getType(ext),
      fileSize: stat.size,
      lastModified: stat.modified,
    );
  }

  @override
  Future<String> getFileContent(String filePath) async {
    return _fileSystemService.readFileContent(filePath);
  }
}
