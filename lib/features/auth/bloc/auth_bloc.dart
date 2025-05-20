import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/auth_repo.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AbstractAuthRepositories authRepositories;

  AuthBloc(this.authRepositories) : super(AuthInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await authRepositories.fetchUsers();
        emit(UsersLoaded(users: users));
      } catch (e, st) {
        emit(UsersLoadingFailure(exception: e));
        GetIt.instance<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });
  }

  @override //ловит ошибки только вне блока try catch
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
