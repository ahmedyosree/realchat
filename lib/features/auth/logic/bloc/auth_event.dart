import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Base class for authentication events.
/// Uses Equatable for value comparison.
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event triggered when signing in with email and password.
class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

/// Event triggered when registering with email and password.
class RegisterWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String nickname;

  RegisterWithEmailEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.nickname,
  });

  @override
  List<Object?> get props => [email, password, name, nickname];
}

/// Event triggered when signing in with Google.
class SignInWithGoogleEvent extends AuthEvent {}

/// Event triggered to check if a user session exists (if user already logged in).
class CheckUserSession extends AuthEvent {}

/// Event triggered when signing out.
class SignOutEvent extends AuthEvent {}

/// Event triggered when a user wants to change Gmail while signing in.
class ChangeGmailWhileSigningInEvent extends AuthEvent {}

/// Event triggered when additional user information needs to be added
/// after signing in with Google.
class AddInfoEvent extends AuthEvent {
  final User firebaseUser;
  final String name;
  final String nickname;

  AddInfoEvent({
    required this.firebaseUser,
    required this.name,
    required this.nickname,
  });
}
