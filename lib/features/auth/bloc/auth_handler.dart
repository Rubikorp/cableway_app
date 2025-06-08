import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../repositories/auth_repo.dart/auth_repo.dart';
import '../../../repositories/auth_repo.dart/models/models.dart';
import '../auth.dart';

/// Обрабатывает выход пользователя из системы.
///
/// Удаляет данные текущего пользователя из [authBox] и
/// переводит приложение в состояние [Unauthenticated].
///
/// [emit] — функция для обновления состояния BLoC.
/// [authBox] — локальное хранилище (Hive), содержащее данные авторизованного пользователя.
Future<void> logoutRequestedHandler(
  Emitter<AuthState> emit,
  Box<UserInfo> authBox,
) async {
  await authBox.delete('currentUser');
  emit(Unauthenticated());
}

/// Проверяет статус авторизации пользователя при запуске приложения.
///
/// Получает текущего сохранённого пользователя из [authBox] и сверяет его
/// с актуальным списком пользователей из [authRepositories].
///
/// Если пользователь найден и совпадает по имени и паролю —
/// эмитит [Authenticated], иначе — [Unauthenticated].
///
/// В случае ошибок авторизации (например, проблемы с сетью) также эмитит [Unauthenticated],
/// а подробности ошибки передаёт в [Talker].
///
/// [emit] — функция для обновления состояния BLoC.
/// [authBox] — локальное хранилище (Hive) с сохранённым пользователем.
/// [authRepositories] — репозиторий для получения актуального списка пользователей.
Future<void> checkAuthStatusHandler(
  Emitter<AuthState> emit,
  Box<UserInfo> authBox,
  AbstractAuthRepositories authRepositories,
) async {
  GetIt.I<Talker>().debug('Проверка авторизации');
  try {
    final users = await authRepositories.fetchUsers();
    final savedUser = authBox.get('currentUser');

    final user = users.firstWhereOrNull(
      (u) =>
          savedUser != null &&
          u.name.trim() == savedUser.name.trim() &&
          u.password.trim() == savedUser.password.trim(),
    );

    if (savedUser != null && user != null) {
      GetIt.I<Talker>().debug('Авторизован как ${savedUser.name}');
      emit(Authenticated(savedUser));
    } else {
      emit(Unauthenticated());
    }
  } catch (e, st) {
    GetIt.I<Talker>().debug('Не авторизован из-за ошибки');
    GetIt.I<Talker>().error(e, st);
    emit(Unauthenticated());
  }
}
