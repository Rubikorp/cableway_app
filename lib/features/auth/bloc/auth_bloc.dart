import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/auth_repo.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AbstractAuthRepositories authRepositories;
  final Box<UserInfo> authBox;

  AuthBloc(this.authRepositories, this.authBox) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      try {
        final users = await authRepositories.fetchUsers();
        final user = users.firstWhere(
          (u) =>
              u.name.trim() == event.username.trim() &&
              u.password.trim() == event.password.trim(),
          orElse: () => throw Exception('Неверный логин или пароль'),
        );

        await authBox.put('currentUser', user);
        emit(Authenticated(user));
      } catch (e, st) {
        emit(AuthFailed());
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authBox.delete('currentUser');
      emit(Unauthenticated());
    });

    on<CheckAuthStatus>((event, emit) async {
      GetIt.I<Talker>().debug('Проверка авторизации');
      final savedUser = authBox.get('currentUser');
      if (savedUser != null) {
        GetIt.I<Talker>().debug('Авторизован как ${savedUser.name}');
        emit(Authenticated(savedUser));
      } else {
        GetIt.I<Talker>().debug('Не авторизован');
        emit(Unauthenticated());
      }
    });
  }

  @override //ловит ошибки только вне блока try catch
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
