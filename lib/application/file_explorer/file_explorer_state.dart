import 'package:equatable/equatable.dart';
import '../../domain/entities/file_node_entity.dart';

abstract class FileExplorerState extends Equatable {
  const FileExplorerState();
  @override
  List<Object?> get props => [];
}

class FileExplorerInitial extends FileExplorerState {
  const FileExplorerInitial();
}

class FileExplorerLoading extends FileExplorerState {
  const FileExplorerLoading();
}

class FileExplorerLoaded extends FileExplorerState {
  final String rootPath;
  final List<FileNodeEntity> nodes;

  const FileExplorerLoaded({required this.rootPath, required this.nodes});

  FileExplorerLoaded copyWith({
    String? rootPath,
    List<FileNodeEntity>? nodes,
  }) {
    return FileExplorerLoaded(
      rootPath: rootPath ?? this.rootPath,
      nodes: nodes ?? this.nodes,
    );
  }

  @override
  List<Object?> get props => [rootPath, nodes];
}

class FileExplorerError extends FileExplorerState {
  final String message;
  const FileExplorerError(this.message);
  @override
  List<Object?> get props => [message];
}
