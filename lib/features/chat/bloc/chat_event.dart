part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent extends Equatable{
  const ChatEvent();
  @override
  List<Object> get props => [];
}


class StartNewChatEvent extends ChatEvent {
  final String firstMessage;
  final String friendId;
  final String friendKey;

  const StartNewChatEvent({
    required this.firstMessage,
    required this.friendId,
    required this.friendKey,
  });
  @override
  List<Object> get props => [firstMessage, friendId, friendKey];
}

class GetChatsEvent extends ChatEvent {}


class StopGettingChatsEvent extends ChatEvent {}

// NEW: Internal event for updated chats list
class ChatsUpdated extends ChatEvent {
  final List<ChatModel> chats;
  const ChatsUpdated(this.chats);

  @override
  List<Object> get props => [chats];
}

// NEW: Internal event for error
class ChatsError extends ChatEvent {
  final String error;
  const ChatsError(this.error);

  @override
  List<Object> get props => [error];
}