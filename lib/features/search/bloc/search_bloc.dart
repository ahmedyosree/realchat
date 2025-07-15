import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/user.dart';
import '../data/repositories/search_repository.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  Timer? _debounce;
  static const _debounceDuration = Duration(milliseconds: 500); // Reduced from 1 second

  SearchBloc({required SearchRepository searchRepository})
      : _searchRepository = searchRepository,
        super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchRequested>(_onSearchRequested);
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event,
      Emitter<SearchState> emit,
      ) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      add(SearchRequested(query: event.query));
    });
  }

  Future<void> _onSearchRequested(
      SearchRequested event,
      Emitter<SearchState> emit,
      ) async {
    if (event.query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    final myID = _searchRepository.myUserId;

    emit(SearchLoading(myID));

    try {
      final users = await _searchRepository.searchUsersByNickname(
        event.query,

      );

      emit(SearchLoaded(users , myID));
    } catch (e) {
      emit(SearchError('Failed to load search results: ${e.toString()}' , myID) );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _searchRepository.clearCache();
    return super.close();
  }
}