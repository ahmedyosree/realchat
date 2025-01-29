abstract class AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent(this.email, this.password);
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
}


class SignInWithGoogleEvent extends AuthEvent {}

class CheckCurrentUserEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
