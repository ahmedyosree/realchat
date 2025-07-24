import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realchat/services/firebase_firestore_user_service.dart';
import '../features/auth/data/repositories/authentication_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_event.dart';
import '../features/chat/bloc/ChatMessagesBloc/message_bloc.dart';
import '../features/chat/bloc/ChatOverviewBloc/chat_bloc.dart';
import '../features/chat/data/repositories/chat_repositories.dart';
import '../features/search/bloc/search_bloc.dart';
import '../features/search/data/repositories/search_repository.dart';
import '../router/app_router.dart';
import '../services/encryption_service.dart';
import '../services/firebase_firestore_chat_service.dart';
import '../services/local_storage_service.dart';
import '../features/auth/data/services/firebase_authentication_service.dart';

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final FirebaseAuthService firebaseAuthService;
  final FireStoreUserService fireStoreService;
  final FireStoreChatService fireStoreChatService;
  final EncryptionService encryptionService;

  const MyApp({
    super.key,
    required this.localStorageService,
    required this.firebaseAuthService,
    required this.fireStoreService,
    required this.fireStoreChatService,
    required this.encryptionService,
  });

  @override
  Widget build(BuildContext context) {
    return  MultiRepositoryProvider(
        providers: [
        RepositoryProvider<ChatRepository>(
        create: (_) => ChatRepository(
      firestoreChatService: fireStoreChatService,
      localStorageService: localStorageService,
      fireStoreUserService: fireStoreService,
      encryptionService: encryptionService,
    ),
    ),
    ],
    child:

      MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            AuthenticationRepository(
              firebaseAuthService: firebaseAuthService,
              localStorageService: localStorageService,
              fireStoreService: fireStoreService,
              encryptionService2: encryptionService,
            ),
          )..add(CheckUserSession()),
        ),
        BlocProvider(
          create: (context) => SearchBloc(
            searchRepository: SearchRepository(fireStoreService: fireStoreService,
              localStorageService: localStorageService,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ChatBloc(
            chatRepository:  context.read<ChatRepository>(),
        ),
        ),
        BlocProvider(
          create: (context) => MessageBloc(
            chatRepository:  context.read<ChatRepository>(),
          ),
        ),
      ],
      child: const AppRouter(),
    ));
  }
}
