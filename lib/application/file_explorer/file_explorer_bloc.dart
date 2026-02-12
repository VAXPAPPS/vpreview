import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/file_node_entity.dart';
import '../../infrastructure/file_system_service.dart';
import 'file_explorer_event.dart';
import 'file_explorer_state.dart';

class FileExplorerBloc extends Bloc<FileExplorerEvent, FileExplorerState> {
  final FileSystemService _fileSystemService;

  FileExplorerBloc(this._fileSystemService) : super(const FileExplorerInitial()) {
    on<LoadDirectory>(_onLoadDirectory);
    on<ToggleDirectory>(_onToggleDirectory);
    on<RefreshDirectory>(_onRefreshDirectory);
  }

  Future<void> _onLoadDirectory(LoadDirectory event, Emitter<FileExplorerState> emit) async {
    emit(const FileExplorerLoading());
    try {
      final nodes = await _fileSystemService.listDirectory(event.path);
      emit(FileExplorerLoaded(rootPath: event.path, nodes: nodes));
    } catch (e) {
      emit(FileExplorerError('Failed to load directory: $e'));
    }
  }

  Future<void> _onToggleDirectory(ToggleDirectory event, Emitter<FileExplorerState> emit) async {
    if (state is! FileExplorerLoaded) return;
    final loaded = state as FileExplorerLoaded;

    final updatedNodes = await _toggleNode(loaded.nodes, event.path);
    emit(loaded.copyWith(nodes: updatedNodes));
  }

  Future<void> _onRefreshDirectory(RefreshDirectory event, Emitter<FileExplorerState> emit) async {
    if (state is! FileExplorerLoaded) return;
    final loaded = state as FileExplorerLoaded;
    add(LoadDirectory(loaded.rootPath));
  }

  Future<List<FileNodeEntity>> _toggleNode(List<FileNodeEntity> nodes, String path) async {
    final result = <FileNodeEntity>[];
    for (final node in nodes) {
      if (node.path == path && node.isDirectory) {
        if (node.isExpanded) {
          // Collapse
          result.add(node.copyWith(isExpanded: false, children: []));
        } else {
          // Expand: load children
          final children = await _fileSystemService.listDirectory(path);
          result.add(node.copyWith(isExpanded: true, children: children));
        }
      } else if (node.isDirectory && node.isExpanded && node.children.isNotEmpty) {
        // Recurse into expanded directories
        final updatedChildren = await _toggleNode(node.children, path);
        result.add(node.copyWith(children: updatedChildren));
      } else {
        result.add(node);
      }
    }
    return result;
  }
}
