import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/models/Local_Message.dart';
import '../../data/repositories/chat_repositories.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatRepository;
  StreamSubscription<List<LocalMessage>>? _messagesSubscription;

  MessageBloc({required this.chatRepository}) : super(MessageInitial()) {

    on<GetMessagesEvent>(_onGetMessages);
    on<StopGettingMessagesEvent>(_onStopGettingMessages);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<MessagesError>((event, emit) {
      emit(GettingMessagesFailure(event.error));
    });
    on<SendMessage>(_onSendMessage);
  }


  Future<void> _onSendMessage(
      SendMessage event,
      Emitter<MessageState> emit,
      ) async {
    try {
      await chatRepository.addNewMessage(event.text, event.chatId);
    } catch (error) {

      emit(SendMessageFailure(error.toString()));
    }
  }

  Future<void> _onGetMessages(
      GetMessagesEvent event,
      Emitter<MessageState> emit,
      ) async {
    // Cancel any previous subscription to prevent duplicate listeners
    await _messagesSubscription?.cancel();


    // Listen to SQLite for real-time UI updates via stream
    _messagesSubscription = chatRepository.watchMessagesForChat(event.chatId).listen(
          (messages) => add(MessagesUpdated(messages, event.name , event.nickname , event.chatId)), // Dispatch event with new messages
      onError: (error) => add(MessagesError(error.toString())),
    );
  }

  Future<void> _onMessagesUpdated(
      MessagesUpdated event,
      Emitter<MessageState> emit,
      ) async {
    emit(StartGettingMessages(messages: event.messages , myId: chatRepository.myUserId , name: event.name , nickname: event.nickname , chatId: event.chatId));
  }

  Future<void> _onStopGettingMessages(
      StopGettingMessagesEvent event,
      Emitter<MessageState> emit,
      ) async {
    try {
      await _messagesSubscription?.cancel();
      _messagesSubscription = null;
      emit(const StopGettingMessages());
    } catch (e) {
      emit(GettingMessagesFailure("Error stopping message sync: ${e.toString()}"));
    }
  }



  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }

}
