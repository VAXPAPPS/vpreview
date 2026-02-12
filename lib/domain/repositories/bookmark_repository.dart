import '../entities/bookmark_entity.dart';

/// Abstract repository for bookmark operations.
abstract class BookmarkRepository {
  Future<void> addBookmark(BookmarkEntity bookmark);
  Future<void> removeBookmark(String bookmarkId);
  Future<List<BookmarkEntity>> getBookmarks();
  Future<List<BookmarkEntity>> getBookmarksForDocument(String documentPath);
}
