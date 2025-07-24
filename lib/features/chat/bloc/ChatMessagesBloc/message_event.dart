part of 'message_bloc.dart';

@immutable
sealed class MessageEvent extends Equatable{
  const MessageEvent();
  @override
  List<Object> get props => [];
}


class SendMessage extends MessageEvent {
  final String text;
  final String chatId;
  const SendMessage(this.text , this.chatId);
  @override
  List<Object> get props => [text , chatId];
}


class GetMessagesEvent extends MessageEvent {
  final String chatId;
  final String name;
  final String nickname;
  const GetMessagesEvent(this.chatId , this.name , this.nickname);
  @override
  List<Object> get props => [chatId , name , nickname];
}


class StopGettingMessagesEvent extends MessageEvent {}


class MessagesUpdated extends MessageEvent {
  final List<LocalMessage> messages;
  final String name;
  final String nickname;
  final String chatId;
  const MessagesUpdated(this.messages , this.name , this.nickname , this.chatId);

  @override
  List<Object> get props => [messages , name , nickname , chatId];
}


class MessagesError extends MessageEvent {
  final String error;
  const MessagesError(this.error);

  @override
  List<Object> get props => [error];
}

