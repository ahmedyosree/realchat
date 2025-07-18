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


class SendMessageFailure extends ChatState {
  final String error;
  const SendMessageFailure(this.error);

  @override
  List<Object> get props => [error];
}

class StartGettingMessages extends ChatState {
  final List<LocalMessage> messages;
  final String myId;
  final String name;
  final String nickname;
  final String chatId;

  const StartGettingMessages({this.messages = const [] , required this.myId , required this.name , required this.nickname , required this.chatId});

  @override
  List<Object> get props => [messages , myId , name , nickname , chatId];
}

class StopGettingMessages extends ChatState {
  const StopGettingMessages();
}

class GettingMessagesFailure extends ChatState {
  final String error;
  const GettingMessagesFailure(this.error);

  @override
  List<Object> get props => [error];
}