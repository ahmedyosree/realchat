
import 'package:bloc/bloc.dart';
import '../../../core/exceptions/auth_exception.dart';
import '../../../services/AuthenticationRepository.dart';
import 'auth_event.dart';
import 'auth_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      print('Processing event: ${event.runtimeType}');
    }, transformer: (events, mapper) {
      return events.asyncExpand(mapper);
    });
    on<CheckUserSession>(_onCheckUserSession);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    print('Current state: ${transition.currentState.runtimeType}');
    print('Next state: ${transition.nextState.runtimeType}');
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
    print('Checking user session...');

    emit(AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        print('User session found: ${user.email}');
        emit(AuthSuccess(user));
      } else {
        print('No user session found');
        emit(AuthInitial());
      }
    } catch (e) {
      print('Error checking user session: $e');
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