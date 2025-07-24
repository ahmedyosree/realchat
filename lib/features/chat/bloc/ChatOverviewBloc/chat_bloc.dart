import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/chat_preview.dart';
import '../../data/repositories/chat_repositories.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription<List<ChatPreview>>? _chatsSubscription;


  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<StartNewChatEvent>(_onCreateChat);
    on<GetChatsEvent>(_onGetChats);
    on<StopGettingChatsEvent>(_onStopGettingChats);
    on<ChatsUpdated>(_onChatsUpdated);
    on<ChatsError>((event, emit) {
      emit(GettingChatsFailure(event.error));
    });



  }

  Future<void> _onCreateChat(
      StartNewChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(StartNewChatInProgress());
    try {
      await chatRepository.startNewChat(event.firstMessage, event.friendId , event.friendKey);
    } catch (error) {

      emit(StartNewChatFailure(error.toString()));
    }
  }

  Future<void> _onGetChats(
      GetChatsEvent event,
      Emitter<ChatState> emit,
      ) async {
    // Cancel any previous subscription to prevent duplicate listeners
    await _chatsSubscription?.cancel();

    // Start Firestore -> SQLite sync in the background
    chatRepository.startChatSync();
    chatRepository.startMessageSync();
    // Listen to SQLite for real-time UI updates via stream
    _chatsSubscription = chatRepository.watchChatPreviews().listen(
          (chatsPreview) => add(ChatsUpdated(chatsPreview)), // Dispatch event with new chats
      onError: (error) => add(ChatsError(error.toString())),
    );
  }

  Future<void> _onChatsUpdated(
      ChatsUpdated event,
      Emitter<ChatState> emit,
      ) async {
    emit(StartGettingChats(chatPreview: event.chatsChatPreview , myId: chatRepository.myUserId));
  }

  Future<void> _onStopGettingChats(
      StopGettingChatsEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      await chatRepository.stopChatSync();
      await _chatsSubscription?.cancel();
      await chatRepository.stopMessageSync();
      _chatsSubscription = null;
      emit(const StopGettingChats());
    } catch (e) {
      emit(GettingChatsFailure("Error stopping chat sync: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }


}
