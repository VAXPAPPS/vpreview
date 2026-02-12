import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  final bool isSearchBarVisible;
  const SearchInitial({this.isSearchBarVisible = false});
  @override
  List<Object?> get props => [isSearchBarVisible];
}

class SearchResults extends SearchState {
  final String query;
  final List<SearchMatch> matches;
  final int currentMatchIndex;
  final bool isSearchBarVisible;

  const SearchResults({
    required this.query,
    required this.matches,
    this.currentMatchIndex = 0,
    this.isSearchBarVisible = true,
  });

  SearchResults copyWith({
    String? query,
    List<SearchMatch>? matches,
    int? currentMatchIndex,
    bool? isSearchBarVisible,
  }) {
    return SearchResults(
      query: query ?? this.query,
      matches: matches ?? this.matches,
      currentMatchIndex: currentMatchIndex ?? this.currentMatchIndex,
      isSearchBarVisible: isSearchBarVisible ?? this.isSearchBarVisible,
    );
  }

  int get totalMatches => matches.length;
  bool get hasMatches => matches.isNotEmpty;

  @override
  List<Object?> get props => [query, matches, currentMatchIndex, isSearchBarVisible];
}

class SearchMatch extends Equatable {
  final int startIndex;
  final int endIndex;
  final int lineNumber;
  final String lineContent;

  const SearchMatch({
    required this.startIndex,
    required this.endIndex,
    required this.lineNumber,
    required this.lineContent,
  });

  @override
  List<Object?> get props => [startIndex, endIndex, lineNumber, lineContent];
}
