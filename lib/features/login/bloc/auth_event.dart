import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

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

class SignInWithGoogleEvent extends AuthEvent {}

class CheckUserSession extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
