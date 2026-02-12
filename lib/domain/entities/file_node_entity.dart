import 'package:equatable/equatable.dart';

/// Represents a node in the file explorer tree.
class FileNodeEntity extends Equatable {
  final String path;
  final String name;
  final bool isDirectory;
  final List<FileNodeEntity> children;
  final bool isExpanded;

  const FileNodeEntity({
    required this.path,
    required this.name,
    required this.isDirectory,
    this.children = const [],
    this.isExpanded = false,
  });

  FileNodeEntity copyWith({
    String? path,
    String? name,
    bool? isDirectory,
    List<FileNodeEntity>? children,
    bool? isExpanded,
  }) {
    return FileNodeEntity(
      path: path ?? this.path,
      name: name ?? this.name,
      isDirectory: isDirectory ?? this.isDirectory,
      children: children ?? this.children,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [path, name, isDirectory, children, isExpanded];
}
