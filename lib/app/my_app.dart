import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realchat/services/firebase_firestore.dart';

import '../features/auth/data/repositories/authentication_repository.dart';
import '../features/auth/logic/bloc/auth_bloc.dart';
import '../features/auth/logic/bloc/auth_event.dart';
import '../router/app_router.dart';
import '../services/LocalStorageService.dart';
import '../services/firebase_authentication_service.dart';

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final FirebaseAuthService firebaseAuthService;
  final FireStoreService fireStoreService;

  const MyApp({
    super.key,
    required this.localStorageService,
    required this.firebaseAuthService,
    required this.fireStoreService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        AuthenticationRepository(
          firebaseAuthService: firebaseAuthService,
          localStorageService: localStorageService,
          fireStoreService: fireStoreService,
        ),
      )..add(CheckUserSession()),
      child: const AppRouter(),
    );
  }
}
