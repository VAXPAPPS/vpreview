import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/recent_files_repository.dart';
import 'recent_files_event.dart';
import 'recent_files_state.dart';

class RecentFilesBloc extends Bloc<RecentFilesEvent, RecentFilesState> {
  final RecentFilesRepository _recentFilesRepository;

  RecentFilesBloc(this._recentFilesRepository) : super(const RecentFilesInitial()) {
    on<LoadRecentFiles>(_onLoadRecentFiles);
    on<AddRecentFile>(_onAddRecentFile);
    on<ClearRecentFiles>(_onClearRecentFiles);
  }

  Future<void> _onLoadRecentFiles(LoadRecentFiles event, Emitter<RecentFilesState> emit) async {
    final files = await _recentFilesRepository.getRecentFiles();
    emit(RecentFilesLoaded(files));
  }

  Future<void> _onAddRecentFile(AddRecentFile event, Emitter<RecentFilesState> emit) async {
    await _recentFilesRepository.addRecentFile(event.filePath);
    add(const LoadRecentFiles());
  }

  Future<void> _onClearRecentFiles(ClearRecentFiles event, Emitter<RecentFilesState> emit) async {
    await _recentFilesRepository.clearRecentFiles();
    emit(const RecentFilesLoaded([]));
  }
}
