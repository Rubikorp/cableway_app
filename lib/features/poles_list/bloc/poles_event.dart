part of 'poles_bloc.dart';

/// Базовый класс событий для [PolesBloc].
abstract class PolesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Событие загрузки списка опор.
///
/// Может использоваться [completer], чтобы отслеживать завершение загрузки,
/// например, при pull-to-refresh.
class LoadPoles extends PolesEvent {
  /// Completer, позволяющий отслеживать завершение загрузки (необязательный).
  final Completer? completer;

  /// Создает событие загрузки опор.
  LoadPoles({this.completer});

  @override
  List<Object?> get props => [completer];
}

/// Событие сортировки списка опор.
///
/// При первом вызове сортирует по срочности и номеру.
/// При повторном — возвращает оригинальный порядок.
class SortPoles extends PolesEvent {
  @override
  List<Object?> get props => [];
}

/// Событие фильтрации опор по номеру или описанию ремонта.
///
/// Поиск нечувствителен к регистру.
class SearchPole extends PolesEvent {
  /// Поисковый запрос.
  final String query;

  /// Создает событие фильтрации.
  SearchPole({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Событие сброса сортировки и фильтрации.
///
/// Возвращает отображаемый список к исходному состоянию.
class ResetPoles extends PolesEvent {
  @override
  List<Object?> get props => [];
}

/// Событие удаления опоры по ID.
///
/// [deletePoleId] — идентификатор опоры.
/// [completer] используется для оповещения об окончании удаления.
class DeletePole extends PolesEvent {
  final String deletePoleId;
  final Completer? completer;

  /// Создает событие удаления опоры.
  DeletePole({required this.deletePoleId, this.completer});

  @override
  List<Object?> get props => [deletePoleId, completer];
}
