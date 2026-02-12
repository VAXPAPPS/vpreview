import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/search/search_bloc.dart';
import '../../../application/search/search_event.dart';
import '../../../application/search/search_state.dart';

class SearchBarWidget extends StatefulWidget {
  final String? currentContent;

  const SearchBarWidget({super.key, this.currentContent});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search() {
    if (widget.currentContent != null) {
      context.read<SearchBloc>().add(
        StartSearch(query: _controller.text, content: widget.currentContent!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final isVisible = state is SearchInitial
            ? state.isSearchBarVisible
            : state is SearchResults
                ? state.isSearchBarVisible
                : false;

        if (!isVisible) return const SizedBox.shrink();

        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2E),
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
          ),
          child: Row(
            children: [
              // Search field
              Expanded(
                child: SizedBox(
                  height: 28,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (_) => _search(),
                    onSubmitted: (_) => context.read<SearchBloc>().add(const NextResult()),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'بحث...',
                      hintStyle: const TextStyle(fontSize: 12, color: Colors.white24),
                      prefixIcon: const Icon(Icons.search, size: 14, color: Colors.white38),
                      prefixIconConstraints: const BoxConstraints(minWidth: 32),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Results count
              if (state is SearchResults)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    state.hasMatches
                        ? '${state.currentMatchIndex + 1}/${state.totalMatches}'
                        : 'لا نتائج',
                    style: TextStyle(
                      fontSize: 11,
                      color: state.hasMatches ? Colors.white54 : Colors.redAccent,
                    ),
                  ),
                ),

              // Navigation arrows
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_up, size: 16),
                onPressed: () => context.read<SearchBloc>().add(const PreviousResult()),
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                color: Colors.white54,
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                onPressed: () => context.read<SearchBloc>().add(const NextResult()),
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                color: Colors.white54,
              ),

              // Close
              IconButton(
                icon: const Icon(Icons.close, size: 14),
                onPressed: () {
                  _controller.clear();
                  context.read<SearchBloc>().add(const ClearSearch());
                },
                iconSize: 14,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                color: Colors.white38,
              ),
            ],
          ),
        );
      },
    );
  }
}
