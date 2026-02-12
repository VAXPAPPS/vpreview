import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository _bookmarkRepository;

  BookmarkBloc(this._bookmarkRepository) : super(const BookmarkInitial()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<AddBookmark>(_onAddBookmark);
    on<RemoveBookmark>(_onRemoveBookmark);
  }

  Future<void> _onLoadBookmarks(LoadBookmarks event, Emitter<BookmarkState> emit) async {
    try {
      final bookmarks = await _bookmarkRepository.getBookmarks();
      emit(BookmarkLoaded(bookmarks));
    } catch (e) {
      emit(BookmarkError('Failed to load bookmarks: $e'));
    }
  }

  Future<void> _onAddBookmark(AddBookmark event, Emitter<BookmarkState> emit) async {
    try {
      final bookmark = BookmarkEntity(
        id: '${event.documentPath}_${event.pageNumber}_${DateTime.now().millisecondsSinceEpoch}'
            .hashCode.toRadixString(36),
        documentPath: event.documentPath,
        pageNumber: event.pageNumber,
        label: event.label,
        createdAt: DateTime.now(),
      );
      await _bookmarkRepository.addBookmark(bookmark);
      add(const LoadBookmarks());
    } catch (e) {
      emit(BookmarkError('Failed to add bookmark: $e'));
    }
  }

  Future<void> _onRemoveBookmark(RemoveBookmark event, Emitter<BookmarkState> emit) async {
    try {
      await _bookmarkRepository.removeBookmark(event.bookmarkId);
      add(const LoadBookmarks());
    } catch (e) {
      emit(BookmarkError('Failed to remove bookmark: $e'));
    }
  }
}
