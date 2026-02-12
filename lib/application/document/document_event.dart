import 'package:equatable/equatable.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

/// Open a document by file path.
class OpenDocument extends DocumentEvent {
  final String filePath;
  const OpenDocument(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// Close a document tab by its file path.
class CloseDocument extends DocumentEvent {
  final String filePath;
  const CloseDocument(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// Switch to a specific tab by file path.
class SwitchTab extends DocumentEvent {
  final String filePath;
  const SwitchTab(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// Close all open document tabs.
class CloseAllDocuments extends DocumentEvent {
  const CloseAllDocuments();
}

/// Reorder tabs by moving from oldIndex to newIndex.
class ReorderTabs extends DocumentEvent {
  final int oldIndex;
  final int newIndex;
  const ReorderTabs(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
