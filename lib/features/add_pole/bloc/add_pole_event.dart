part of 'add_pole_bloc.dart';

/// Базовый класс событий для [AddPoleBloc].
///
/// Все события, которые обрабатываются в блоке добавления опоры, должны
/// наследоваться от этого класса.
abstract class AddPoleBlocEvent extends Equatable {
  const AddPoleBlocEvent();
}

/// Событие для отправки данных новой опоры на сервер.
///
/// Обычно вызывается при финальном нажатии кнопки "Сохранить".
///
/// [number] — номер новой опоры.
/// [completer] — опциональный `Completer`, чтобы можно было
/// дождаться завершения сохранения (например, для показа лоадера или закрытия экрана).
class LoadAddPole extends AddPoleBlocEvent {
  final Completer? completer;
  final String number;

  const LoadAddPole({this.completer, required this.number});

  @override
  List<Object?> get props => [completer, number];
}

/// Событие для добавления одного ремонта к опоре.
///
/// Используется для обновления локального списка ремонтов в состоянии [AddPoleLoaded].
///
/// [repair] — объект ремонта, который будет добавлен в текущий список.
class AddRepairPressed extends AddPoleBlocEvent {
  final Repair repair;

  const AddRepairPressed(this.repair);

  @override
  List<Object?> get props => [repair];
}

/// Событие для сброса состояния блока в начальное.
///
/// Обычно используется после успешного добавления опоры или при отмене действия.
/// Переводит блок в состояние [AddPoleLoaded] с пустыми значениями.
class ResetAddPoleState extends AddPoleBlocEvent {
  @override
  List<Object?> get props => [];
}
