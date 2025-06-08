part of 'auth_bloc.dart';

/// Абстрактный класс событий авторизации.
///
/// Используется для определения различных действий,
/// инициируемых пользователем или системой, которые обрабатываются в [AuthBloc].
abstract class AuthEvent extends Equatable {}

/// Событие проверки статуса авторизации.
///
/// Вызывается при старте приложения для проверки,
/// сохранён ли пользователь в локальном хранилище (Hive).
/// Если сохранён — происходит сверка с серверными данными.
class CheckAuthStatus extends AuthEvent {
  @override
  List<Object?> get props => [];
}

/// Событие отправки данных для входа в систему.
///
/// Используется при попытке авторизации пользователя.
/// Передаются следующие параметры:
///
/// - [username] — логин пользователя.
/// - [password] — пароль пользователя.
/// - [completer] — необязательный [Completer], используемый
///   для синхронизации с UI (например, закрытие индикатора загрузки).
class LoginSubmitted extends AuthEvent {
  /// Логин пользователя.
  final String username;

  /// Пароль пользователя.
  final String password;

  /// Completer для завершения асинхронной операции в UI.
  final Completer? completer;

  /// Создает событие [LoginSubmitted] с логином, паролем и необязательным completer.
  LoginSubmitted({
    required this.username,
    required this.password,
    this.completer,
  });

  @override
  List<Object?> get props => [username, password];
}

/// Событие выхода пользователя из аккаунта.
///
/// Вызывает очистку локального хранилища [authBox] и
/// переключает состояние в [Unauthenticated].
class LogoutRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}
