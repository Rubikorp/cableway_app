part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class CheckAuthStatus extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final Completer? completer;
  final String username;
  final String password;

  LoginSubmitted({
    required this.username,
    required this.password,
    this.completer,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [username, password];
}

class LogoutRequested extends AuthEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
