part of 'search_bloc.dart';
sealed class SearchEvent extends Equatable {
  const SearchEvent(); // Add const constructor to base class
}

final class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query) : super();

  @override
  List<Object> get props => [query];
}

final class SearchRequested extends SearchEvent {
  final String query;

  const SearchRequested({required this.query}) : super();

  @override
  List<Object> get props => [query];
}