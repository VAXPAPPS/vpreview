import '../../domain/repositories/recent_files_repository.dart';
import '../../infrastructure/local_storage_service.dart';

class RecentFilesRepositoryImpl implements RecentFilesRepository {
  final LocalStorageService _storage;
  static const String _key = 'recent_files';
  static const int _maxRecentFiles = 20;

  RecentFilesRepositoryImpl(this._storage);

  @override
  Future<void> addRecentFile(String filePath) async {
    final files = await getRecentFiles();
    // Remove if already exists (to move to top)
    files.remove(filePath);
    // Add to beginning
    files.insert(0, filePath);
    // Keep only the latest N files
    if (files.length > _maxRecentFiles) {
      files.removeRange(_maxRecentFiles, files.length);
    }
    await _storage.setStringList(_key, files);
  }

  @override
  Future<List<String>> getRecentFiles() async {
    return await _storage.getStringList(_key);
  }

  @override
  Future<void> clearRecentFiles() async {
    await _storage.setStringList(_key, []);
  }

  @override
  Future<void> removeRecentFile(String filePath) async {
    final files = await getRecentFiles();
    files.remove(filePath);
    await _storage.setStringList(_key, files);
  }
}
