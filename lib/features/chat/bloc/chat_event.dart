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
  final List<ChatPreview> chatsChatPreview;
  const ChatsUpdated(this.chatsChatPreview);

  @override
  List<Object> get props => [chatsChatPreview];
}

// NEW: Internal event for error
class ChatsError extends ChatEvent {
  final String error;
  const ChatsError(this.error);

  @override
  List<Object> get props => [error];
}


class SendMessage extends ChatEvent {
  final String text;
  final String chatId;
  const SendMessage(this.text , this.chatId);
  @override
  List<Object> get props => [text , chatId];
}


class GetMessagesEvent extends ChatEvent {
  final String chatId;
  final String name;
  final String nickname;
  const GetMessagesEvent(this.chatId , this.name , this.nickname);
  @override
  List<Object> get props => [chatId , name , nickname];
}


class StopGettingMessagesEvent extends ChatEvent {}

// NEW: Internal event for updated chats list
class MessagesUpdated extends ChatEvent {
  final List<LocalMessage> messages;
  final String name;
  final String nickname;
  final String chatId;
  const MessagesUpdated(this.messages , this.name , this.nickname , this.chatId);

  @override
  List<Object> get props => [messages , name , nickname , chatId];
}

// NEW: Internal event for error
class MessagesError extends ChatEvent {
  final String error;
  const MessagesError(this.error);

  @override
  List<Object> get props => [error];
}
