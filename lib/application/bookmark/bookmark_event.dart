import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookmarks extends BookmarkEvent {
  const LoadBookmarks();
}

class AddBookmark extends BookmarkEvent {
  final String documentPath;
  final int pageNumber;
  final String label;
  const AddBookmark({required this.documentPath, required this.pageNumber, required this.label});
  @override
  List<Object?> get props => [documentPath, pageNumber, label];
}

class RemoveBookmark extends BookmarkEvent {
  final String bookmarkId;
  const RemoveBookmark(this.bookmarkId);
  @override
  List<Object?> get props => [bookmarkId];
}
