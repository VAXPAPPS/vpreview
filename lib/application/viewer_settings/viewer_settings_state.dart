import 'package:equatable/equatable.dart';

class ViewerSettingsState extends Equatable {
  final double zoomLevel;
  final bool isFullScreen;
  final int currentPage;
  final int totalPages;
  final bool showThumbnails;

  const ViewerSettingsState({
    this.zoomLevel = 1.0,
    this.isFullScreen = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.showThumbnails = false,
  });

  ViewerSettingsState copyWith({
    double? zoomLevel,
    bool? isFullScreen,
    int? currentPage,
    int? totalPages,
    bool? showThumbnails,
  }) {
    return ViewerSettingsState(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      showThumbnails: showThumbnails ?? this.showThumbnails,
    );
  }

  String get zoomPercentage => '${(zoomLevel * 100).round()}%';

  @override
  List<Object?> get props => [zoomLevel, isFullScreen, currentPage, totalPages, showThumbnails];
}
