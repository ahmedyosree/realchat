part of 'chat_bloc.dart';

@immutable
sealed class ChatState  extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class StartNewChatInProgress extends ChatState {}

class StartNewChatSuccess extends ChatState {}

class StartNewChatFailure extends ChatState {
  final String error;
  const StartNewChatFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChatInitial extends ChatState {}

class StartGettingChats extends ChatState {
  final List<ChatPreview> chatPreview;
  final String myId;

  const StartGettingChats({this.chatPreview = const [] , required this.myId} );

  @override
  List<Object> get props => [chatPreview];
}

class StopGettingChats extends ChatState {
  const StopGettingChats();
}

class GettingChatsFailure extends ChatState {
  final String error;
  const GettingChatsFailure(this.error);

  @override
  List<Object> get props => [error];
}

