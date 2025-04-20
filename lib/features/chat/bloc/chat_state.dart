part of 'chat_bloc.dart';

@immutable
sealed class ChatState  extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {}

class ChatFailure extends ChatState {
  final String error;

  const ChatFailure({required this.error});
  @override
  List<Object> get props => [error];
}