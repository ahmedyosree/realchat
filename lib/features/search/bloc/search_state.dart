part of 'search_bloc.dart';
sealed class SearchState extends Equatable {
  const SearchState();
}

final class SearchInitial extends SearchState {
  const SearchInitial() : super();

  @override
  List<Object?> get props => [];
}

final class SearchLoading extends SearchState {
  final List<UserModel>? previousResults;

  const SearchLoading({this.previousResults}) : super();

  @override
  List<Object?> get props => [previousResults];
}

final class SearchLoaded extends SearchState {
  final List<UserModel> users;

  const SearchLoaded(this.users) : super();

  @override
  List<Object> get props => [users];
}

final class SearchError extends SearchState {
  final String message;
  final List<UserModel>? previousResults;

  const SearchError(this.message, {this.previousResults}) : super();

  @override
  List<Object?> get props => [message, previousResults];
}