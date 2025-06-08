import 'package:cable_road_project/features/add_pole/bloc/add_pole_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../../../repositories/poles_list_repo.dart/pole_list_repo.dart';

/// Обрабатывает событие добавления ремонта к текущей опоре.
///
/// Добавляет новый [RepairModel] из [AddRepairPressed.repair] в список
/// [repairs] текущего состояния [AddPoleLoaded] и эмитит обновлённое состояние.
///
/// В случае ошибки логирует исключение через [Talker].
///
/// Параметры:
/// - [event]: событие с данными ремонта для добавления.
/// - [emit]: функция для эмита нового состояния.
/// - [state]: текущее состояние BLoC, ожидается [AddPoleLoaded].
void onAddRepairHandler(
  AddRepairPressed event,
  Emitter<AddPoleBlocState> emit,
  AddPoleBlocState state,
) {
  try {
    final currentState = state as AddPoleLoaded;

    // Создаём новый список ремонтов, добавляя новый
    final updatedRepairs = [...currentState.repairs, event.repair];

    // Эмитим обновлённое состояние с новым списком ремонтов
    emit(currentState.copyWith(repairs: updatedRepairs));
  } catch (e, st) {
    // Логируем ошибку и стек
    GetIt.instance<Talker>().handle(e, st);
  }
}

/// Обрабатывает событие сохранения новой опоры.
///
/// Отправляет данные опоры, включая список ремонтов, в репозиторий
/// через метод [addPole]. В случае ошибки эмитит [AddPoleLoadingFailure]
/// и логирует её через [Talker]. После завершения вызывает [Completer.complete()]
/// для уведомления UI.
///
/// Параметры:
/// - [event]: событие с номером опоры и completer для callback.
/// - [currentState]: текущее состояние, содержащее список ремонтов.
/// - [userName]: имя пользователя, добавляющего опору.
/// - [emit]: функция эмита состояния.
/// - [polesRepository]: репозиторий, сохраняющий опору.
Future<void> onLoadAddPoleHundler(
  LoadAddPole event,
  AddPoleLoaded currentState,
  String userName,
  Emitter<AddPoleBlocState> emit,
  AbstractPoleRepositories polesRepository,
) async {
  try {
    // Отправляем данные опоры в репозиторий
    await polesRepository.addPole(
      PoleAdd(
        number: event.number,
        repairs: currentState.repairs,
        check: true,
        userName: userName,
      ),
    );
  } catch (e, st) {
    // При ошибке эмитим состояние ошибки и логируем
    emit(
      AddPoleLoadingFailure(exception: e) as AddPoleLoaded,
    ); // <- Возможно, здесь ошибка типов!
    GetIt.instance<Talker>().handle(e, st);
  } finally {
    // Завершаем completer, чтобы уведомить UI
    event.completer?.complete();
  }
}
