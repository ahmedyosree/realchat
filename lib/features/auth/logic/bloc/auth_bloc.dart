
import '../../../../core/exceptions/auth_exception.dart';
import '../../data/repositories/AuthenticationRepository.dart';
import 'auth_event.dart';
import 'auth_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthLoading()) {

    on<CheckUserSession>(_onCheckUserSession);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
  }



  Future<void> _onSignInWithEmail(
      SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(event.email, event.password);
      emit(AuthSuccess(user!, welcomeMessage: 'Welcome, ${user.email}!'));
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onRegisterWithEmail(
      RegisterWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.registerWithEmail(
        event.email,
        event.password,
        event.name,
        event.nickname,
      );
      emit(AuthSuccess(user!, welcomeMessage: 'Welcome, ${user.email}!'));
    } catch (e) {
      emit(AuthFailure(e is AuthException ? e.message : 'Registration failed. Please try again.'));
    }
  }

  Future<void> _onSignInWithGoogle(SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        await Future.delayed(const Duration(milliseconds: 300));
        emit(AuthSuccess(user, welcomeMessage: 'Welcome, ${user.email}!'));
      }
      // Silent handling for null user (cancellation)
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Google sign-in failed. Please try again.'));
    }
  }

  Future<void> _onCheckUserSession(
      CheckUserSession event, Emitter<AuthState> emit) async {

    emit(AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure('Failed to check user session. Please try again.'));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure('Logout failed. Please try again.'));
    }
  }
}