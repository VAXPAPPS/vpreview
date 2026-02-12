import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/consts/supported_extensions.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/repositories/recent_files_repository.dart';
import 'document_event.dart';
import 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository _documentRepository;
  final RecentFilesRepository _recentFilesRepository;

  DocumentBloc(this._documentRepository, this._recentFilesRepository)
      : super(const DocumentInitial()) {
    on<OpenDocument>(_onOpenDocument);
    on<CloseDocument>(_onCloseDocument);
    on<SwitchTab>(_onSwitchTab);
    on<CloseAllDocuments>(_onCloseAllDocuments);
    on<ReorderTabs>(_onReorderTabs);
  }

  Future<void> _onOpenDocument(OpenDocument event, Emitter<DocumentState> emit) async {
    // Check if already open
    if (state is DocumentLoaded) {
      final loaded = state as DocumentLoaded;
      final existing = loaded.openDocuments.where((d) => d.filePath == event.filePath);
      if (existing.isNotEmpty) {
        emit(loaded.copyWith(activeDocumentPath: event.filePath));
        return;
      }
    }

    // Get current open documents
    final currentDocs = state is DocumentLoaded
        ? (state as DocumentLoaded).openDocuments.toList()
        : <dynamic>[];
    final currentTexts = state is DocumentLoaded
        ? Map<String, String>.from((state as DocumentLoaded).textContents)
        : <String, String>{};

    emit(DocumentLoading(
      openDocuments: List.unmodifiable(currentDocs),
      activeDocumentPath: event.filePath,
    ));

    try {
      final document = await _documentRepository.loadDocument(event.filePath);
      currentDocs.add(document);

      // Load text content for text and markdown files
      if (document.documentType == DocumentType.text ||
          document.documentType == DocumentType.markdown) {
        final content = await _documentRepository.getFileContent(event.filePath);
        currentTexts[event.filePath] = content;
      }

      // Add to recent files
      await _recentFilesRepository.addRecentFile(event.filePath);

      emit(DocumentLoaded(
        openDocuments: List.unmodifiable(currentDocs),
        activeDocumentPath: event.filePath,
        textContents: Map.unmodifiable(currentTexts),
      ));
    } catch (e) {
      emit(DocumentError(
        message: 'Failed to open: ${e.toString()}',
        openDocuments: List.unmodifiable(currentDocs),
        activeDocumentPath: currentDocs.isNotEmpty ? currentDocs.last.filePath : null,
      ));
    }
  }

  void _onCloseDocument(CloseDocument event, Emitter<DocumentState> emit) {
    if (state is! DocumentLoaded) return;
    final loaded = state as DocumentLoaded;

    final docs = loaded.openDocuments.where((d) => d.filePath != event.filePath).toList();
    final texts = Map<String, String>.from(loaded.textContents)..remove(event.filePath);

    if (docs.isEmpty) {
      emit(const DocumentInitial());
      return;
    }

    String activePath = loaded.activeDocumentPath;
    if (activePath == event.filePath) {
      // Switch to previous tab or first available
      final closedIndex = loaded.openDocuments.indexWhere((d) => d.filePath == event.filePath);
      final newIndex = closedIndex > 0 ? closedIndex - 1 : 0;
      activePath = docs[newIndex.clamp(0, docs.length - 1)].filePath;
    }

    emit(DocumentLoaded(
      openDocuments: docs,
      activeDocumentPath: activePath,
      textContents: texts,
    ));
  }

  void _onSwitchTab(SwitchTab event, Emitter<DocumentState> emit) {
    if (state is! DocumentLoaded) return;
    final loaded = state as DocumentLoaded;
    emit(loaded.copyWith(activeDocumentPath: event.filePath));
  }

  void _onCloseAllDocuments(CloseAllDocuments event, Emitter<DocumentState> emit) {
    emit(const DocumentInitial());
  }

  void _onReorderTabs(ReorderTabs event, Emitter<DocumentState> emit) {
    if (state is! DocumentLoaded) return;
    final loaded = state as DocumentLoaded;

    final docs = List.of(loaded.openDocuments);
    final item = docs.removeAt(event.oldIndex);
    final newIndex = event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
    docs.insert(newIndex, item);

    emit(loaded.copyWith(openDocuments: docs));
  }
}
