part of 'repair_list_bloc_bloc.dart';

/// Абстрактный класс для событий [RepairListBlocBloc].
///
/// Все события, обрабатываемые в RepairListBloc, должны наследоваться от этого класса.
abstract class RepairListBlocEvent extends Equatable {}

/// Событие для загрузки списка ремонтов для определённой опоры.
///
/// Используется при открытии экрана с ремонтами.
///
/// [pole] — опора, для которой необходимо отобразить ремонты.
class LoadRepairList extends RepairListBlocEvent {
  /// Опора, ремонты которой нужно загрузить.
  final Pole pole;

  /// Конструктор события [LoadRepairList].
  LoadRepairList({required this.pole});

  @override
  List<Object?> get props => [pole];
}

/// Событие переключения отображения завершённых ремонтов.
///
/// Используется для смены фильтра: показывать все ремонты или только активные.
class ToggleRepairCompletionViewEvent extends RepairListBlocEvent {
  @override
  List<Object?> get props => [];
}
