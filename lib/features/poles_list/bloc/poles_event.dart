part of 'poles_bloc.dart';

/// Базовый класс событий для [PolesBloc].
abstract class PolesEvent extends Equatable {}

/// Событие загрузки списка опор.
///
/// Может использоваться [Completer], чтобы сигнализировать завершение загрузки.
class LoadPoles extends PolesEvent {
  /// Completer, позволяющий отслеживать завершение загрузки (необязательно).
  final Completer? completer;

  /// Создает событие загрузки опор.
  LoadPoles({this.completer});

  @override
  List<Object?> get props => [completer];
}

/// Событие сортировки опор.
///
/// Повторный вызов отменяет сортировку и восстанавливает исходный список.
class SortPoles extends PolesEvent {
  @override
  List<Object?> get props => [];
}

/// Событие поиска опор по номеру или описанию ремонта.
///
/// [query] — строка для поиска, регистр не учитывается.
class SearchPole extends PolesEvent {
  /// Поисковый запрос.
  final String query;

  /// Создает событие поиска.
  SearchPole({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Событие сброса фильтрации или сортировки списка опор.
class ResetPoles extends PolesEvent {
  @override
  List<Object?> get props => [];
}
