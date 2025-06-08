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
import 'auth_handler.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC, отвечающий за аутентификацию пользователя.
///
/// Обрабатывает следующие события:
/// - [LoginSubmitted] — попытка входа.
/// - [LogoutRequested] — выход из системы.
/// - [CheckAuthStatus] — проверка текущего состояния авторизации.
///
/// Использует:
/// - [AbstractAuthRepositories] для получения списка пользователей с сервера.
/// - [authBox] (Hive) для хранения текущего авторизованного пользователя локально.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Репозиторий, предоставляющий доступ к данным пользователей.
  final AbstractAuthRepositories authRepositories;

  /// Hive-хранилище, где сохраняется текущий авторизованный пользователь.
  final Box<UserInfo> authBox;

  /// Создает экземпляр [AuthBloc] с переданным репозиторием [authRepositories]
  /// и локальным хранилищем [authBox].
  ///
  /// При инициализации подписывается на обработку следующих событий:
  /// - [LoginSubmitted]
  /// - [LogoutRequested]
  /// - [CheckAuthStatus]
  AuthBloc(this.authRepositories, this.authBox) : super(AuthInitial()) {
    /// Обработка события входа в систему [LoginSubmitted].
    ///
    /// Проверяет введенные имя пользователя и пароль, сравнивая с данными
    /// из [authRepositories]. В случае успеха сохраняет пользователя в Hive
    /// и эмитит [Authenticated]. В случае ошибки — соответствующее состояние:
    /// - [AuthFailed] — неверные логин или пароль.
    /// - [NotLink] — отсутствие соединения.
    /// - [LongLink] — таймаут при подключении.
    /// - [OtherErrorLink] — другая ошибка при входе.
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
        emit(OtherErrorLink()); // любая другая ошибка
        GetIt.I<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });

    /// Обработка события выхода пользователя [LogoutRequested].
    ///
    /// Удаляет текущего пользователя из [authBox] и сбрасывает состояние.
    on<LogoutRequested>((event, emit) async {
      await logoutRequestedHandler(emit, authBox);
    });

    /// Обработка события проверки авторизации [CheckAuthStatus].
    ///
    /// Проверяет, есть ли сохранённый пользователь в [authBox], и,
    /// при необходимости, получает свежие данные пользователя из [authRepositories].
    on<CheckAuthStatus>((event, emit) async {
      await checkAuthStatusHandler(emit, authBox, authRepositories);
    });
  }

  /// Глобальный перехватчик ошибок внутри BLoC.
  ///
  /// Все ошибки пробрасываются в логгер [Talker] для отслеживания.
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
