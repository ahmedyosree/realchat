import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:realchat/services/AuthenticationRepository.dart';
import 'package:realchat/services/LocalStorageService.dart';
import 'package:realchat/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/firebase_options.dart';
import 'features/login/bloc/auth_bloc.dart';
import 'features/login/bloc/auth_event.dart';
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
  final localStorageService = LocalStorageService(prefs);

  // Run the app with the initialized services
  runApp(MyApp(localStorageService: localStorageService));
}

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;

  const MyApp({super.key, required this.localStorageService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthenticationRepository(
        firebaseService: FirebaseService(),
        localStorageService: localStorageService,
      ))
        ..add(CheckUserSession()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;
    final currentPath = state.matchedLocation;

    // Define route groups for better organization
    final protectedRoutes = ['/home'];
    final publicRoutes = ['/login', '/signup', '/'];

    // During loading, only allow splash screen
    if (authState is AuthLoading) {
      return currentPath == '/' ? null : '/';
    }

    // If authenticated
    if (authState is AuthSuccess) {
      // If trying to access public routes (login, signup, splash), redirect to home
      if (publicRoutes.contains(currentPath)) {
        return '/home';
      }
      // Allow access to protected routes
      return null;
    }

    // If not authenticated (including AuthFailure, AuthLoggedOut)
    if (protectedRoutes.contains(currentPath)) {
      return '/login';
    }

    // Allow access to public routes when not authenticated
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home', // Add the name here
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);
