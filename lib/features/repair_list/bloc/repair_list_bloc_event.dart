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

class AddRepairLocal extends RepairListBlocEvent {
  final Repair repair;
  AddRepairLocal({required this.repair});
  @override
  List<Object?> get props => [repair];
}

class DeleteRepairLocal extends RepairListBlocEvent {
  final Repair repair;
  DeleteRepairLocal(this.repair);
  @override
  List<Object?> get props => [repair];
}

class EditRepairLocal extends RepairListBlocEvent {
  final Repair oldRepair;
  final String newDescription;
  final bool newUrgent;
  EditRepairLocal({
    required this.oldRepair,
    required this.newDescription,
    required this.newUrgent,
  });
  @override
  List<Object?> get props => [oldRepair, newDescription, newUrgent];
}

class ToggleRepairCompletedLocal extends RepairListBlocEvent {
  final Repair repair;
  ToggleRepairCompletedLocal(this.repair);
  @override
  List<Object?> get props => [repair];
}

class SubmitRepairs extends RepairListBlocEvent {
  SubmitRepairs();

  @override
  List<Object?> get props => [];
}
