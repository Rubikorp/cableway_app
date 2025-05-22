part of 'auth_bloc.dart';

/// Абстрактный класс состояний для BLoC авторизации.
///
/// Используется для управления различными состояниями входа пользователя в систему.
abstract class AuthState extends Equatable {}

/// Начальное состояние авторизации.
///
/// Устанавливается по умолчанию при запуске приложения.
class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

/// Состояние загрузки списка пользователей.
///
/// Используется, когда идет запрос к базе данных или API.
class UsersLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

/// Состояние успешной авторизации.
///
/// Содержит [user] — объект авторизованного пользователя.
class Authenticated extends AuthState {
  /// Авторизованный пользователь.
  final UserInfo user;

  /// Создает состояние [Authenticated] с переданным пользователем.
  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Состояние, когда пользователь не авторизован.
///
/// Используется, например, после выхода из аккаунта.
class Unauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

/// Состояние ошибки авторизации (неверный логин или пароль).
///
/// Используется, чтобы показать сообщение об ошибке входа.
/// [key] применяется для форсирования обновления UI.
class AuthFailed extends AuthState {
  /// Уникальный ключ для обновления UI.
  final UniqueKey key = UniqueKey();

  @override
  List<Object?> get props => [key];
}

/// Состояние ошибки при отсутствии соединения с сервером.
///
/// Показывает, что нет сети или API недоступен.
class NotLink extends AuthState {
  /// Уникальный ключ для обновления UI.
  final UniqueKey key = UniqueKey();

  @override
  List<Object?> get props => [key];
}

/// Состояние долгого ожидания ответа от сервера.
///
/// Используется, если соединение есть, но оно слишком медленное.
class LongLink extends AuthState {
  /// Уникальный ключ для обновления UI.
  final UniqueKey key = UniqueKey();

  @override
  List<Object?> get props => [key];
}

/// Состояние неизвестной ошибки при попытке подключения.
///
/// Например, ошибка формата ответа, исключения и пр.
class OtherErrorLink extends AuthState {
  /// Уникальный ключ для обновления UI.
  final UniqueKey key = UniqueKey();

  @override
  List<Object?> get props => [key];
}
