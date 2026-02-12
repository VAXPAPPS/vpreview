import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchInitial()) {
    on<StartSearch>(_onStartSearch);
    on<ClearSearch>(_onClearSearch);
    on<NextResult>(_onNextResult);
    on<PreviousResult>(_onPreviousResult);
    on<ToggleSearchBar>(_onToggleSearchBar);
  }

  void _onStartSearch(StartSearch event, Emitter<SearchState> emit) {
    if (event.query.isEmpty) {
      emit(const SearchInitial(isSearchBarVisible: true));
      return;
    }

    final matches = <SearchMatch>[];
    final queryLower = event.query.toLowerCase();
    // ignore: unused_local_variable
    final contentLower = event.content.toLowerCase();
    final lines = event.content.split('\n');

    int globalIndex = 0;
    for (int lineNum = 0; lineNum < lines.length; lineNum++) {
      final line = lines[lineNum];
      final lineLower = line.toLowerCase();
      int searchFrom = 0;
      while (true) {
        final idx = lineLower.indexOf(queryLower, searchFrom);
        if (idx == -1) break;
        matches.add(SearchMatch(
          startIndex: globalIndex + idx,
          endIndex: globalIndex + idx + event.query.length,
          lineNumber: lineNum + 1,
          lineContent: line.trim(),
        ));
        searchFrom = idx + 1;
      }
      globalIndex += line.length + 1; // +1 for \n
    }

    emit(SearchResults(
      query: event.query,
      matches: matches,
      currentMatchIndex: 0,
    ));
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(const SearchInitial(isSearchBarVisible: false));
  }

  void _onNextResult(NextResult event, Emitter<SearchState> emit) {
    if (state is! SearchResults) return;
    final s = state as SearchResults;
    if (s.matches.isEmpty) return;
    final next = (s.currentMatchIndex + 1) % s.matches.length;
    emit(s.copyWith(currentMatchIndex: next));
  }

  void _onPreviousResult(PreviousResult event, Emitter<SearchState> emit) {
    if (state is! SearchResults) return;
    final s = state as SearchResults;
    if (s.matches.isEmpty) return;
    final prev = (s.currentMatchIndex - 1 + s.matches.length) % s.matches.length;
    emit(s.copyWith(currentMatchIndex: prev));
  }

  void _onToggleSearchBar(ToggleSearchBar event, Emitter<SearchState> emit) {
    if (state is SearchResults) {
      final s = state as SearchResults;
      emit(s.copyWith(isSearchBarVisible: !s.isSearchBarVisible));
    } else if (state is SearchInitial) {
      final s = state as SearchInitial;
      emit(SearchInitial(isSearchBarVisible: !s.isSearchBarVisible));
    }
  }
}
