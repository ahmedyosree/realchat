part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent extends Equatable{
  const ChatEvent();
  @override
  List<Object> get props => [];
}


class CreateChatEvent extends ChatEvent {
  final String firstMessage;
  final String friendId;

  const CreateChatEvent({
    required this.firstMessage,
    required this.friendId,
  });
  @override
  List<Object> get props => [firstMessage, friendId];
}