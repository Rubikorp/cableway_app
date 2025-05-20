part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class UsersLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class UsersLoaded extends AuthState {
  final List<UserInfo> users;

  UsersLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class UsersLoadingFailure extends AuthState {
  final Object? exception;

  UsersLoadingFailure({this.exception});

  @override
  // TODO: implement props
  List<Object?> get props => [exception];
}
