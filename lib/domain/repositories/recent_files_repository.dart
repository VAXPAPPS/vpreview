/// Abstract repository for recent files operations.
abstract class RecentFilesRepository {
  Future<void> addRecentFile(String filePath);
  Future<List<String>> getRecentFiles();
  Future<void> clearRecentFiles();
  Future<void> removeRecentFile(String filePath);
}
