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
  final String friendKey;

  const CreateChatEvent({
    required this.firstMessage,
    required this.friendId,
    required this.friendKey,
  });
  @override
  List<Object> get props => [firstMessage, friendId, friendKey];
}