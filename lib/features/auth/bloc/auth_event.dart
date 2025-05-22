part of 'auth_bloc.dart';

/// Абстрактный класс событий авторизации.
///
/// Используется для определения различных действий,
/// инициируемых пользователем или системой.
abstract class AuthEvent extends Equatable {}

/// Событие проверки статуса авторизации.
///
/// Вызывается при старте приложения для проверки,
/// сохранен ли пользователь в локальном хранилище.
class CheckAuthStatus extends AuthEvent {
  @override
  List<Object?> get props => [];
}

/// Событие отправки данных для входа в систему.
///
/// Используется при попытке авторизации пользователя.
/// Передаются следующие параметры:
///
/// [username] — введенный логин
/// [password] — введенный пароль
/// [completer] — необязательный [Completer], используется для синхронизации с UI (например, закрытие лоадера)
class LoginSubmitted extends AuthEvent {
  /// Логин пользователя.
  final String username;

  /// Пароль пользователя.
  final String password;

  /// Completer для управления асинхронным завершением (например, закрытие диалога загрузки).
  final Completer? completer;

  /// Создает событие [LoginSubmitted] с логином и паролем.
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
/// Удаляет текущего пользователя из локального хранилища [authBox].
class LogoutRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}
