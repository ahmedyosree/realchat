import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../chat/bloc/chat_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print("1");
        if (state is AuthSuccess) {
          print("whaaaart");
          print("2");
          context.go('/home');
        } else if (state is AuthFailure) {
          print("3");
          context.go('/login');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthInitial) {
          print("4");
          context.go('/login');
        }
        else if (state is RegisterFailure) {
          print("4.5");
          context.go('/login');

          context.push('/signup');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        // Don't navigate if state is Loading or Initial
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your app logo or branding here
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading...'),
            ],
          ),
        ),
      ),
    );
  }
}