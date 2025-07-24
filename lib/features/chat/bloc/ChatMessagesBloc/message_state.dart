part of 'message_bloc.dart';

@immutable
sealed class MessageState extends Equatable{
  const MessageState();
  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}


class SendMessageFailure extends MessageState {
  final String error;
  const SendMessageFailure(this.error);

  @override
  List<Object> get props => [error];
}

class StartGettingMessages extends MessageState {
  final List<LocalMessage> messages;
  final String myId;
  final String name;
  final String nickname;
  final String chatId;

  const StartGettingMessages({this.messages = const [] , required this.myId , required this.name , required this.nickname , required this.chatId});

  @override
  List<Object> get props => [messages , myId , name , nickname , chatId];
}

class StopGettingMessages extends MessageState {
  const StopGettingMessages();
}

class GettingMessagesFailure extends MessageState {
  final String error;
  const GettingMessagesFailure(this.error);

  @override
  List<Object> get props => [error];
}
