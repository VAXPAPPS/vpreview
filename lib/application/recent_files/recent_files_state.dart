import 'package:equatable/equatable.dart';

abstract class RecentFilesState extends Equatable {
  const RecentFilesState();
  @override
  List<Object?> get props => [];
}

class RecentFilesInitial extends RecentFilesState {
  const RecentFilesInitial();
}

class RecentFilesLoaded extends RecentFilesState {
  final List<String> files;
  const RecentFilesLoaded(this.files);
  @override
  List<Object?> get props => [files];
}
