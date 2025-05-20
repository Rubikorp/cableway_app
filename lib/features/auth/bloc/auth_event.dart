part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class LoadUsers extends AuthEvent {
  final Completer? completer;

  LoadUsers({this.completer});

  @override
  List<Object?> get props => [completer];
}
