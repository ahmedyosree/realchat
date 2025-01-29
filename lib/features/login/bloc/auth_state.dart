import '../../../models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  final String? welcomeMessage;

  AuthSuccess(this.user, {this.welcomeMessage});
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthLoggedOut extends AuthState {}
