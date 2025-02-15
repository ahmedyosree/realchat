import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/user.dart';

/// Base class for authentication states.
/// Uses Equatable for value comparison.
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// State representing a failure during registration with Email and pass.
class RegisterFailure extends AuthState {
  final String message;

  RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Initial state before any authentication process begins (Log In Screen).
class AuthInitial extends AuthState {}

/// State representing an ongoing authentication process.
class AuthLoading extends AuthState {}

/// State representing a successful authentication (Home Screen).
class AuthSuccess extends AuthState {
  final UserModel user;
  final String? welcomeMessage;

  AuthSuccess(this.user, {this.welcomeMessage});

  @override
  List<Object?> get props => [user, welcomeMessage];
}

/// State representing a general authentication failure.
class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// State representing the need to add additional user information (Name and NickName)
/// after signing in with Google for first time.
class AddInfo extends AuthState {
  final User firebaseUser;
  AddInfo({required this.firebaseUser});
}
