import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/data/repositories/AuthenticationRepository.dart';
import '../features/auth/logic/bloc/auth_bloc.dart';
import '../features/auth/logic/bloc/auth_event.dart';
import '../router/app_router.dart';
import '../services/LocalStorageService.dart';
import '../services/firebase_service.dart';

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final FirebaseService firebaseService;

  const MyApp({
    super.key,
    required this.localStorageService,
    required this.firebaseService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        AuthenticationRepository(
          firebaseService: firebaseService,
          localStorageService: localStorageService,
        ),
      )..add(CheckUserSession()),
      child: const AppRouter(),
    );
  }
}
