import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realchat/services/firebase_firestore_user_service.dart';

import '../features/auth/data/repositories/authentication_repository.dart';
import '../features/auth/logic/bloc/auth_bloc.dart';
import '../features/auth/logic/bloc/auth_event.dart';
import '../features/search/bloc/search_bloc.dart';
import '../features/search/data/repositories/search_repository.dart';
import '../router/app_router.dart';
import '../features/auth/data/services/local_storage_service.dart';
import '../features/auth/data/services/firebase_authentication_service.dart';

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final FirebaseAuthService firebaseAuthService;
  final FireStoreUserService fireStoreService;

  const MyApp({
    super.key,
    required this.localStorageService,
    required this.firebaseAuthService,
    required this.fireStoreService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            AuthenticationRepository(
              firebaseAuthService: firebaseAuthService,
              localStorageService: localStorageService,
              fireStoreService: fireStoreService,
            ),
          )..add(CheckUserSession()),
        ),
        BlocProvider(
          create: (context) => SearchBloc(
            searchRepository: SearchRepository(fireStoreService: fireStoreService),
          ),
        ),
      ],
      child: const AppRouter(),
    );
  }
}
