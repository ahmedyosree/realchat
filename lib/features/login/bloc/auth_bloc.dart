import 'package:bloc/bloc.dart';

import '../../../core/exceptions/auth_exception.dart';
import '../../../services/AuthenticationRepository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<CheckCurrentUserEvent>(_onCheckCurrentUser);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSignInWithEmail(
      SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(event.email, event.password);
      emit(AuthSuccess(user!, welcomeMessage: 'Welcome, ${user.email}!'));
    } catch (e) {
      emit(AuthFailure(e is AuthException ? e.message : 'Login failed. Please try again.'));
    }
  }

  // Similar error handling for other methods
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

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthSuccess(user!, welcomeMessage: 'Welcome, ${user.email}!'));
    } catch (e) {
      emit(AuthFailure(e is AuthException ? e.message : 'Google sign-in failed. Please try again.'));
    }
  }

  Future<void> _onCheckCurrentUser(
      CheckCurrentUserEvent event, Emitter<AuthState> emit) async {
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthLoggedOut());
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure('Logout failed. Please try again.'));
    }
  }
}
