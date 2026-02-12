import 'dart:io';
import 'package:path/path.dart' as p;
import '../core/consts/supported_extensions.dart';
import '../domain/entities/file_node_entity.dart';

/// Service for interacting with the file system.
class FileSystemService {
  /// Lists directory contents filtered by supported extensions.
  Future<List<FileNodeEntity>> listDirectory(String directoryPath) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) return [];

    final entities = <FileNodeEntity>[];
    try {
      await for (final entity in dir.list(followLinks: false)) {
        final name = p.basename(entity.path);
        // Skip hidden files/directories
        if (name.startsWith('.')) continue;

        if (entity is Directory) {
          entities.add(FileNodeEntity(
            path: entity.path,
            name: name,
            isDirectory: true,
          ));
        } else if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (SupportedExtensions.isSupported(ext)) {
            entities.add(FileNodeEntity(
              path: entity.path,
              name: name,
              isDirectory: false,
            ));
          }
        }
      }
    } catch (e) {
      // Permission denied or other errors
      return [];
    }

    // Sort: directories first, then files, both alphabetically
    entities.sort((a, b) {
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return entities;
  }

  /// Reads the text content of a file.
  Future<String> readFileContent(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }
    return file.readAsString();
  }

  /// Gets file metadata.
  Future<FileStat> getFileStat(String filePath) async {
    return File(filePath).stat();
  }

  /// Gets the file size in bytes.
  Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return 0;
    return file.length();
  }

  /// Checks if a file exists.
  Future<bool> fileExists(String filePath) async {
    return File(filePath).exists();
  }

  /// Gets home directory path.
  String getHomePath() {
    return Platform.environment['HOME'] ?? '/home';
  }
}
