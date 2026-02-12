import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class StartSearch extends SearchEvent {
  final String query;
  final String content;
  const StartSearch({required this.query, required this.content});
  @override
  List<Object?> get props => [query, content];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

class NextResult extends SearchEvent {
  const NextResult();
}

class PreviousResult extends SearchEvent {
  const PreviousResult();
}

class ToggleSearchBar extends SearchEvent {
  const ToggleSearchBar();
}
