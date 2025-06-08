part of 'auth_bloc.dart';

/// Абстрактный класс состояний для BLoC авторизации.
///
/// Используется для управления различными состояниями входа пользователя в систему:
/// - начальная инициализация,
/// - загрузка пользователей,
/// - успешная или неуспешная авторизация,
/// - различные ошибки соединения.
abstract class AuthState extends Equatable {}

/// Начальное состояние авторизации.
///
/// Устанавливается при запуске приложения или перезапуске BLoC.
class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

/// Состояние, когда выполняется загрузка списка пользователей.
///
/// Применяется при попытке входа в систему, пока идёт запрос к API или БД.
class UsersLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

/// Состояние успешной авторизации пользователя.
///
/// Содержит информацию об авторизованном пользователе [user].
class Authenticated extends AuthState {
  /// Авторизованный пользователь.
  final UserInfo user;

  /// Создаёт состояние [Authenticated] с переданным [user].
  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Состояние, когда пользователь не авторизован.
///
/// Обычно наступает после выхода из системы.
class Unauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

/// Состояние ошибки при вводе неверных логина или пароля.
///
/// Отображается сообщение об ошибке.
/// [key] используется для форсирования обновления UI (например, повторный показ SnackBar).
class AuthFailed extends AuthState {
  /// Уникальный ключ для обновления UI.
  final UniqueKey key = UniqueKey();

  @override
  List<Object?> get props => [key];
}

/// Состояние отсутствия соединения с сервером.
///
/// Применяется при [SocketException] — нет интернета или сервер недоступен.
class NotLink extends AuthState {
  /// Уникальный ключ для обновления UI.
  final UniqueKey key = UniqueKey();

  @override
  List<Object?> get props => [key];
}

/// Состояние, когда соединение с сервером слишком медленное.
///
/// Применяется при [TimeoutException].
class LongLink extends AuthState {
  /// Уникальный ключ для обновления UI.
  final UniqueKey key = UniqueKey();

  @override
  List<Object?> get props => [key];
}

/// Состояние других, непредвиденных ошибок при попытке входа.
///
/// Пример: ошибка парсинга, неожиданный формат ответа от сервера и т.п.
class OtherErrorLink extends AuthState {
  /// Уникальный ключ для обновления UI.
  final UniqueKey key = UniqueKey();

  @override
  List<Object?> get props => [key];
}
