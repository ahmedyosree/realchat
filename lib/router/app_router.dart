import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/logic/bloc/auth_bloc.dart';
import '../features/auth/logic/bloc/auth_state.dart';
import '../features/auth/presentation/view/SplashScreen.dart';
import '../features/auth/presentation/view/home_page.dart';
import '../features/auth/presentation/view/login_page.dart';
import '../features/auth/presentation/view/setup_profile_page.dart';
import '../features/auth/presentation/view/signup_page.dart';
import 'go_router_refresh_stream.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late final GoRouter _router;
  late final GoRouterRefreshStream _refreshListener;

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    _refreshListener = GoRouterRefreshStream(authBloc.stream);
    _router = _createRouter();
  }

  @override
  void dispose() {
    _refreshListener.dispose();
    super.dispose();
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: _refreshListener,
      redirect: _handleRedirect,
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
          path: '/addinfo',
          name: 'addinfo',
          builder: (context, state) => const SetupProfileScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignUpScreen(),
        ),
      ],
    );
  }

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;
    final currentPath = state.matchedLocation;

    if (authState is AuthLoading) {
      return currentPath == '/' ? null : '/';
    }

    if (authState is AuthSuccess) {
      if (['/', '/login', '/signup'].contains(currentPath)) {
        return '/home';
      }
      return null;
    }

    if (authState is AddInfo) {
      // Only redirect to '/addinfo' if we aren't already there.
      if (currentPath != '/addinfo') {
        return '/addinfo';
      }
    }

    if (currentPath == '/') {
      return '/login';
    }

    if (['/home'].contains(currentPath)) {
      return '/login';
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        primarySwatch: Colors.red,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}
