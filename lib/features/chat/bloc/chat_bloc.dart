import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../data/repositories/chat_repositories.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<CreateChatEvent>(_onCreateChat);

  }

  Future<void> _onCreateChat(
      CreateChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoading());
    try {
      await chatRepository.createChat(event.firstMessage, event.friendId );
      emit(ChatSuccess());
    } catch (error) {
      emit(ChatFailure(error: error.toString()));
    }
  }
}
