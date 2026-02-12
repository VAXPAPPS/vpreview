import 'package:equatable/equatable.dart';

abstract class RecentFilesEvent extends Equatable {
  const RecentFilesEvent();
  @override
  List<Object?> get props => [];
}

class LoadRecentFiles extends RecentFilesEvent {
  const LoadRecentFiles();
}

class AddRecentFile extends RecentFilesEvent {
  final String filePath;
  const AddRecentFile(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class ClearRecentFiles extends RecentFilesEvent {
  const ClearRecentFiles();
}
