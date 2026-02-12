import '../entities/document_entity.dart';

/// Abstract repository for document operations.
abstract class DocumentRepository {
  /// Loads a document from the given file path.
  Future<DocumentEntity> loadDocument(String filePath);

  /// Gets the text content of a file (for text and markdown types).
  Future<String> getFileContent(String filePath);
}
