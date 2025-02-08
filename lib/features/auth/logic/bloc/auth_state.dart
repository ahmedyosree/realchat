import 'package:equatable/equatable.dart';

import '../../../../core/models/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  final String? welcomeMessage;

  AuthSuccess(this.user, {this.welcomeMessage});

  @override
  List<Object?> get props => [user, welcomeMessage];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

