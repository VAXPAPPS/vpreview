import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'viewer_settings_event.dart';
import 'viewer_settings_state.dart';

class ViewerSettingsBloc extends Bloc<ViewerSettingsEvent, ViewerSettingsState> {
  static const double _minZoom = 0.25;
  static const double _maxZoom = 5.0;
  static const double _zoomStep = 0.25;

  ViewerSettingsBloc() : super(const ViewerSettingsState()) {
    on<ZoomIn>(_onZoomIn);
    on<ZoomOut>(_onZoomOut);
    on<ResetZoom>(_onResetZoom);
    on<SetZoomLevel>(_onSetZoomLevel);
    on<ToggleFullScreen>(_onToggleFullScreen);
    on<GoToPage>(_onGoToPage);
    on<SetTotalPages>(_onSetTotalPages);
    on<ToggleThumbnails>(_onToggleThumbnails);
  }

  void _onZoomIn(ZoomIn event, Emitter<ViewerSettingsState> emit) {
    final newZoom = (state.zoomLevel + _zoomStep).clamp(_minZoom, _maxZoom);
    emit(state.copyWith(zoomLevel: newZoom));
  }

  void _onZoomOut(ZoomOut event, Emitter<ViewerSettingsState> emit) {
    final newZoom = (state.zoomLevel - _zoomStep).clamp(_minZoom, _maxZoom);
    emit(state.copyWith(zoomLevel: newZoom));
  }

  void _onResetZoom(ResetZoom event, Emitter<ViewerSettingsState> emit) {
    emit(state.copyWith(zoomLevel: 1.0));
  }

  void _onSetZoomLevel(SetZoomLevel event, Emitter<ViewerSettingsState> emit) {
    final newZoom = event.zoomLevel.clamp(_minZoom, _maxZoom);
    emit(state.copyWith(zoomLevel: newZoom));
  }

  Future<void> _onToggleFullScreen(ToggleFullScreen event, Emitter<ViewerSettingsState> emit) async {
    final newFullScreen = !state.isFullScreen;
    if (newFullScreen) {
      await windowManager.setFullScreen(true);
    } else {
      await windowManager.setFullScreen(false);
    }
    emit(state.copyWith(isFullScreen: newFullScreen));
  }

  void _onGoToPage(GoToPage event, Emitter<ViewerSettingsState> emit) {
    final page = event.page.clamp(1, state.totalPages);
    emit(state.copyWith(currentPage: page));
  }

  void _onSetTotalPages(SetTotalPages event, Emitter<ViewerSettingsState> emit) {
    emit(state.copyWith(totalPages: event.totalPages));
  }

  void _onToggleThumbnails(ToggleThumbnails event, Emitter<ViewerSettingsState> emit) {
    emit(state.copyWith(showThumbnails: !state.showThumbnails));
  }
}
