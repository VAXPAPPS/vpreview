import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpreview/core/colors/vaxp_colors.dart';
import 'package:vpreview/core/venom_layout.dart';
import 'package:window_manager/window_manager.dart';
import 'core/theme/vaxp_theme.dart';
import 'package:venom_config/venom_config.dart';

// Infrastructure
import 'infrastructure/file_system_service.dart';
import 'infrastructure/local_storage_service.dart';

// Data
import 'data/repositories/document_repository_impl.dart';
import 'data/repositories/bookmark_repository_impl.dart';
import 'data/repositories/recent_files_repository_impl.dart';

// BLoCs
import 'application/document/document_bloc.dart';
import 'application/file_explorer/file_explorer_bloc.dart';
import 'application/file_explorer/file_explorer_event.dart';
import 'application/viewer_settings/viewer_settings_bloc.dart';
import 'application/search/search_bloc.dart';
import 'application/bookmark/bookmark_bloc.dart';
import 'application/bookmark/bookmark_event.dart';
import 'application/recent_files/recent_files_bloc.dart';
import 'application/recent_files/recent_files_event.dart';

// Pages
import 'presentation/pages/document_viewer_page.dart';

Future<void> main() async {
  // Initialize Flutter bindings first to ensure the binary messenger is ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Venom Config System
  await VenomConfig().init();

  // Initialize VaxpColors listeners
  VaxpColors.init();

  // Initialize window manager for desktop controls
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(800, 500),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'VAXP Document Viewer',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Initialize services
  final fileSystemService = FileSystemService();
  final localStorageService = LocalStorageService();

  // Initialize repositories
  final documentRepository = DocumentRepositoryImpl(fileSystemService);
  final bookmarkRepository = BookmarkRepositoryImpl(localStorageService);
  final recentFilesRepository = RecentFilesRepositoryImpl(localStorageService);

  runApp(VaxpDocumentViewer(
    fileSystemService: fileSystemService,
    documentRepository: documentRepository,
    bookmarkRepository: bookmarkRepository,
    recentFilesRepository: recentFilesRepository,
  ));
}

class VaxpDocumentViewer extends StatelessWidget {
  final FileSystemService fileSystemService;
  final DocumentRepositoryImpl documentRepository;
  final BookmarkRepositoryImpl bookmarkRepository;
  final RecentFilesRepositoryImpl recentFilesRepository;

  const VaxpDocumentViewer({
    super.key,
    required this.fileSystemService,
    required this.documentRepository,
    required this.bookmarkRepository,
    required this.recentFilesRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DocumentBloc>(
          create: (_) => DocumentBloc(documentRepository, recentFilesRepository),
        ),
        BlocProvider<FileExplorerBloc>(
          create: (_) => FileExplorerBloc(fileSystemService)
            ..add(LoadDirectory(fileSystemService.getHomePath())),
        ),
        BlocProvider<ViewerSettingsBloc>(
          create: (_) => ViewerSettingsBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(),
        ),
        BlocProvider<BookmarkBloc>(
          create: (_) => BookmarkBloc(bookmarkRepository)
            ..add(const LoadBookmarks()),
        ),
        BlocProvider<RecentFilesBloc>(
          create: (_) => RecentFilesBloc(recentFilesRepository)
            ..add(const LoadRecentFiles()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VAXP Document Viewer',
        theme: VaxpTheme.dark,
        home: const _AppShell(),
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    return VenomScaffold(
      title: 'VAXP Document Viewer',
      body: const DocumentViewerPage(),
    );
  }
}
