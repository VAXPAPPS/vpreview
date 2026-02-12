import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../infrastructure/local_storage_service.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final LocalStorageService _storage;
  static const String _key = 'bookmarks';

  BookmarkRepositoryImpl(this._storage);

  @override
  Future<void> addBookmark(BookmarkEntity bookmark) async {
    final bookmarks = await getBookmarks();
    bookmarks.add(bookmark);
    await _save(bookmarks);
  }

  @override
  Future<void> removeBookmark(String bookmarkId) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b.id == bookmarkId);
    await _save(bookmarks);
  }

  @override
  Future<List<BookmarkEntity>> getBookmarks() async {
    final jsonList = await _storage.getJsonList(_key);
    return jsonList.map((json) => BookmarkEntity.fromJson(json)).toList();
  }

  @override
  Future<List<BookmarkEntity>> getBookmarksForDocument(String documentPath) async {
    final all = await getBookmarks();
    return all.where((b) => b.documentPath == documentPath).toList();
  }

  Future<void> _save(List<BookmarkEntity> bookmarks) async {
    final jsonList = bookmarks.map((b) => b.toJson()).toList();
    await _storage.setJsonList(_key, jsonList);
  }
}
