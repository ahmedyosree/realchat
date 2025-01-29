
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:realchat/services/AuthenticationRepository.dart';
import 'package:realchat/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/firebase_options.dart';
import 'features/login/bloc/auth_bloc.dart';
import 'features/login/bloc/auth_state.dart';
import 'features/login/view/SplashScreen.dart';
import 'features/login/view/home_page.dart';
import 'features/login/view/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/login/view/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  MyApp({super.key, required SharedPreferences prefs})
      : _authenticationRepository = AuthenticationRepository(
    prefs: prefs,
    firebaseService: FirebaseService(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(_authenticationRepository),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final isLoggedIn = authBloc.state is AuthSuccess;
    final currentPath = state.uri.path;

    // Handle splash screen logic
    if (currentPath == '/') {
      return isLoggedIn ? '/home' : '/login';
    }

    // Define public routes
    final publicRoutes = {'/login', '/SignUp'};

    // Redirect unauthenticated users trying to access private routes
    if (!isLoggedIn && !publicRoutes.contains(currentPath)) {
      return '/login';
    }

    // Redirect authenticated users away from auth screens
    if (isLoggedIn && publicRoutes.contains(currentPath)) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),GoRoute(
      path: '/SignUp',
      builder: (context, state) => const SignUpScreen(),
    ),

  ],
);