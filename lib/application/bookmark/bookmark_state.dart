import 'package:equatable/equatable.dart';
import '../../domain/entities/bookmark_entity.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();
  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {
  const BookmarkInitial();
}

class BookmarkLoaded extends BookmarkState {
  final List<BookmarkEntity> bookmarks;
  const BookmarkLoaded(this.bookmarks);

  List<BookmarkEntity> forDocument(String documentPath) {
    return bookmarks.where((b) => b.documentPath == documentPath).toList();
  }

  @override
  List<Object?> get props => [bookmarks];
}

class BookmarkError extends BookmarkState {
  final String message;
  const BookmarkError(this.message);
  @override
  List<Object?> get props => [message];
}
