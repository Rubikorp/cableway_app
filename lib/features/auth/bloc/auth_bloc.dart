import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/auth_repo.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/models/models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

        final user = users.firstWhereOrNull(
          (u) =>
              u.name.trim() == event.username.trim() &&
              u.password.trim() == event.password.trim(),
        );

        if (user == null && users.isNotEmpty) {
          emit(AuthFailed()); // логин или пароль неверны
          return;
        }

        await authBox.put('currentUser', user!);
        emit(Authenticated(user));
      } on SocketException catch (e, st) {
        emit(NotLink()); // нет интернета
        GetIt.I<Talker>().handle(e, st);
      } on TimeoutException catch (e, st) {
        emit(LongLink()); // сервер долго отвечает
        GetIt.I<Talker>().handle(e, st);
      } catch (e, st) {
        emit(OtherErrorLink()); // любая другая сетевая ошибка
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });

    on<LogoutRequested>((event, emit) async {
      await _logoutRequested(emit);
    });

    /// проверка авторизации
    on<CheckAuthStatus>((event, emit) async {
      await _checkAuthStatus(emit);
    });
  }

  Future<void> _logoutRequested(Emitter<AuthState> emit) async {
    await authBox.delete('currentUser');
    emit(Unauthenticated());
  }

  Future<void> _checkAuthStatus(Emitter<AuthState> emit) async {
    GetIt.I<Talker>().debug('Проверка авторизации');
    final users = await authRepositories.fetchUsers();
    final savedUser = authBox.get('currentUser');

    final user = users.firstWhereOrNull(
      (u) =>
          u.name.trim() == savedUser!.name.trim() &&
          u.password.trim() == savedUser.password.trim(),
    );

    if (savedUser != null && user != null) {
      GetIt.I<Talker>().debug('Авторизован как ${savedUser.name}');
      emit(Authenticated(savedUser));
    } else {
      GetIt.I<Talker>().debug('Не авторизован');
      emit(Unauthenticated());
    }
  }

  @override //ловит ошибки только вне блока try catch
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
