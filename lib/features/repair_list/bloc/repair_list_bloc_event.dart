part of 'repair_list_bloc_bloc.dart';

/// Абстрактный класс для всех событий [RepairListBloc].
///
/// Все конкретные события должны наследоваться от этого класса.
abstract class RepairListBlocEvent extends Equatable {
  const RepairListBlocEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для загрузки списка ремонтов для определённой опоры.
///
/// Используется при открытии экрана с ремонтами.
///
/// [pole] — опора, ремонты которой необходимо отобразить.
class LoadRepairList extends RepairListBlocEvent {
  final Pole pole;

  const LoadRepairList({required this.pole});

  @override
  List<Object?> get props => [pole];
}

/// Событие переключения отображения завершённых ремонтов.
///
/// Инвертирует флаг [showCompleted] в состоянии [RepairListLoaded].
class ToggleRepairCompletionViewEvent extends RepairListBlocEvent {
  const ToggleRepairCompletionViewEvent();
}

/// Событие добавления нового ремонта локально.
///
/// [repair] — добавляемый ремонт.
class AddRepairLocal extends RepairListBlocEvent {
  final Repair repair;

  const AddRepairLocal({required this.repair});

  @override
  List<Object?> get props => [repair];
}

/// Событие удаления ремонта локально.
///
/// [repair] — удаляемый ремонт.
class DeleteRepairLocal extends RepairListBlocEvent {
  final Repair repair;

  const DeleteRepairLocal(this.repair);

  @override
  List<Object?> get props => [repair];
}

/// Событие редактирования ремонта локально.
///
/// Заменяет описание и срочность ремонта.
/// [oldRepair] — редактируемый ремонт.
/// [newDescription] — новое описание.
/// [newUrgent] — новое значение срочности.
class EditRepairLocal extends RepairListBlocEvent {
  final Repair oldRepair;
  final String newDescription;
  final bool newUrgent;

  const EditRepairLocal({
    required this.oldRepair,
    required this.newDescription,
    required this.newUrgent,
  });

  @override
  List<Object?> get props => [oldRepair, newDescription, newUrgent];
}

/// Событие переключения статуса выполнения ремонта.
///
/// Инвертирует значение поля [completed].
class ToggleRepairCompletedLocal extends RepairListBlocEvent {
  final Repair repair;

  const ToggleRepairCompletedLocal(this.repair);

  @override
  List<Object?> get props => [repair];
}

/// Событие отправки (сохранения) списка ремонтов на сервер.
///
/// Используется при финализации редактирования.
class SubmitRepairs extends RepairListBlocEvent {
  const SubmitRepairs();

  @override
  List<Object?> get props => [];
}
