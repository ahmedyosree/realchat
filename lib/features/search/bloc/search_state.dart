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
  final String myUserId;

  const SearchLoading(this.myUserId , {this.previousResults}) : super();

  @override
  List<Object?> get props => [previousResults , myUserId];
}

final class SearchLoaded extends SearchState {
  final List<UserModel> users;
  final String myUserId;

  const SearchLoaded(this.users , this.myUserId) : super();

  @override
  List<Object> get props => [users, myUserId];
}

final class SearchError extends SearchState {
  final String message;
  final List<UserModel>? previousResults;
  final String myUserId;

  const SearchError(this.message , this.myUserId, {this.previousResults }) : super();

  @override
  List<Object?> get props => [message, previousResults, myUserId];
}