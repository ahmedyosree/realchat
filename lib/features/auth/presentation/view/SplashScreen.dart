import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/widgets/logo.dart';
import '../../../chat/bloc/ChatOverviewBloc/chat_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {


        if (state is AuthSuccess) {


          context.go('/home');
        } else if (state is AuthFailure) {

          context.go('/login');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthInitial) {

          context.go('/login');


        }
        else if (state is RegisterFailure) {

          context.go('/login');

          context.push('/signup');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        // Don't navigate if state is Loading or Initial
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Center(
          child: Text(
            'Real Chat',
            style: TextStyle(
              fontSize:  40, // large and readable
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
              color: AppColors.accent,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}