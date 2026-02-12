import 'package:equatable/equatable.dart';
import '../../domain/entities/document_entity.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

/// Initial state, no documents open.
class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

/// A document is currently loading.
class DocumentLoading extends DocumentState {
  final List<DocumentEntity> openDocuments;
  final String? activeDocumentPath;

  const DocumentLoading({
    this.openDocuments = const [],
    this.activeDocumentPath,
  });

  @override
  List<Object?> get props => [openDocuments, activeDocumentPath];
}

/// Documents are loaded and ready.
class DocumentLoaded extends DocumentState {
  final List<DocumentEntity> openDocuments;
  final String activeDocumentPath;
  final Map<String, String> textContents; // filePath -> content (for text/md)

  const DocumentLoaded({
    required this.openDocuments,
    required this.activeDocumentPath,
    this.textContents = const {},
  });

  DocumentLoaded copyWith({
    List<DocumentEntity>? openDocuments,
    String? activeDocumentPath,
    Map<String, String>? textContents,
  }) {
    return DocumentLoaded(
      openDocuments: openDocuments ?? this.openDocuments,
      activeDocumentPath: activeDocumentPath ?? this.activeDocumentPath,
      textContents: textContents ?? this.textContents,
    );
  }

  @override
  List<Object?> get props => [openDocuments, activeDocumentPath, textContents];
}

/// An error occurred while loading a document.
class DocumentError extends DocumentState {
  final String message;
  final List<DocumentEntity> openDocuments;
  final String? activeDocumentPath;

  const DocumentError({
    required this.message,
    this.openDocuments = const [],
    this.activeDocumentPath,
  });

  @override
  List<Object?> get props => [message, openDocuments, activeDocumentPath];
}
