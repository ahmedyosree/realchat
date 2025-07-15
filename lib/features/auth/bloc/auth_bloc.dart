import '../../../../core/exceptions/auth_exception.dart';
import '../data/repositories/authentication_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bloc responsible for handling authentication-related events and states.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authRepository;

  /// Initializes the AuthBloc with the authentication repository
  /// and sets up event handlers (tells AuthBloc to call the function whenever a Event is dispatched).
  AuthBloc(this._authRepository) : super(AuthLoading()) {
    on<CheckUserSession>(_onCheckUserSession);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<AddInfoEvent>(_onAddInfo);
    on<ChangeGmailWhileSigningInEvent>(_onChangeGmailWhileSigningIn);
  }

  /// Handles user sign-in using email and password.
  Future<void> _onSignInWithEmail(
      SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user =
          await _authRepository.signInWithEmail(event.email, event.password);
      emit(AuthSuccess(user!, welcomeMessage: 'Welcome, ${user.email}!'));
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred. Please try again.'));
    }
  }

  /// Handles user registration using email and password.
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
      print(user);
      print("user");

      emit(AuthSuccess(user!, welcomeMessage: 'Welcome, ${user.email}!'));
    } on AuthException catch (e) {
      print('🚩 AuthException: ${e.code} – ${e.message}');
      emit(RegisterFailure(e.message));
    } catch (e, st) {
      print('🚩 Unexpected register error: $e\n$st');
      emit(RegisterFailure('Registration failed: ${e.toString()}'));
    }
  }

  /// Handles user sign-in using Google authentication (if it first time it make the user go to Setup Profile Screen).
  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signInWithGoogle();
      if (result?.userModel != null) {
        await Future.delayed(const Duration(milliseconds: 300));
        emit(AuthSuccess(
          result!.userModel!,
          welcomeMessage: 'Welcome, ${result.userModel!.email}!',
        ));
      } else if (result?.firebaseUser != null) {
        emit(AddInfo(firebaseUser: result!.firebaseUser!));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Google sign-in failed. Please try again.'));
    }
  }

  /// Handles adding additional user information after Google sign-in and after that it make the user go to Home Screen.
  Future<void> _onAddInfo(AddInfoEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.registerWithGoogle(
        event.firebaseUser,
        event.name,
        event.nickname,
      );
      emit(AuthSuccess(user!, welcomeMessage: 'Welcome, ${user.email}!'));
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Registration failed. Please try again.'));
    }
  }

  /// Checks if a user session is active.
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
      emit(AuthFailure('Failed to check user session.'));
    }
  }

  /// Handles user sign-out and clears local session data.
  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure('Logout failed. Please try again.'));
    }
  }

  /// Handles changing Gmail while signing in (e.g., switching accounts).
  Future<void> _onChangeGmailWhileSigningIn(
      ChangeGmailWhileSigningInEvent event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.changeGmailWhileSigningIn();
      emit(AuthInitial());
    } catch (e) {
      emit(RegisterFailure('An unexpected error occurred. Please try again.'));
    }
  }
}
