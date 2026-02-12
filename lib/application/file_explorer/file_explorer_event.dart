import 'package:equatable/equatable.dart';

abstract class FileExplorerEvent extends Equatable {
  const FileExplorerEvent();
  @override
  List<Object?> get props => [];
}

class LoadDirectory extends FileExplorerEvent {
  final String path;
  const LoadDirectory(this.path);
  @override
  List<Object?> get props => [path];
}

class ToggleDirectory extends FileExplorerEvent {
  final String path;
  const ToggleDirectory(this.path);
  @override
  List<Object?> get props => [path];
}

class RefreshDirectory extends FileExplorerEvent {
  const RefreshDirectory();
}
