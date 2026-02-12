import 'package:equatable/equatable.dart';

abstract class ViewerSettingsEvent extends Equatable {
  const ViewerSettingsEvent();
  @override
  List<Object?> get props => [];
}

class ZoomIn extends ViewerSettingsEvent {
  const ZoomIn();
}

class ZoomOut extends ViewerSettingsEvent {
  const ZoomOut();
}

class ResetZoom extends ViewerSettingsEvent {
  const ResetZoom();
}

class SetZoomLevel extends ViewerSettingsEvent {
  final double zoomLevel;
  const SetZoomLevel(this.zoomLevel);
  @override
  List<Object?> get props => [zoomLevel];
}

class ToggleFullScreen extends ViewerSettingsEvent {
  const ToggleFullScreen();
}

class GoToPage extends ViewerSettingsEvent {
  final int page;
  const GoToPage(this.page);
  @override
  List<Object?> get props => [page];
}

class SetTotalPages extends ViewerSettingsEvent {
  final int totalPages;
  const SetTotalPages(this.totalPages);
  @override
  List<Object?> get props => [totalPages];
}

class ToggleThumbnails extends ViewerSettingsEvent {
  const ToggleThumbnails();
}
