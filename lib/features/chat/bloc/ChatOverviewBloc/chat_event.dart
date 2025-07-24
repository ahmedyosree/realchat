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

class ChatsUpdated extends ChatEvent {
  final List<ChatPreview> chatsChatPreview;
  const ChatsUpdated(this.chatsChatPreview);

  @override
  List<Object> get props => [chatsChatPreview];
}

class ChatsError extends ChatEvent {
  final String error;
  const ChatsError(this.error);

  @override
  List<Object> get props => [error];
}

