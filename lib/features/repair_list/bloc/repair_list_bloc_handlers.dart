import 'package:cable_road_project/features/poles_list/bloc/poles_bloc.dart';
import 'package:cable_road_project/features/repair_list/bloc/repair_list_bloc_bloc.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/repairs_model.dart';
import 'package:cable_road_project/utils/date_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../auth/auth.dart';

/// Обработка события загрузки списка ремонтов [LoadRepairList].
///
/// Использует переданную опору [event.pole], не делает повторный запрос в репозиторий.
Future<void> onLoadRepairListHandler(
  LoadRepairList event,
  Emitter<RepairListBlocState> emit,
) async {
  try {
    emit(RepairListLoading());

    // Используем опору из события. Список ремонтов уже в ней.
    final pole = event.pole;
    emit(RepairListLoaded(poleList: [pole]));
  } catch (e, st) {
    emit(RepairListLoadingFailure(exception: e));
    GetIt.I<Talker>().handle(e, st);
  }
}

/// Обработка события переключения отображения завершённых ремонтов.
///
/// Инвертирует флаг [showCompleted] в состоянии [RepairListLoaded].
void onToggleViewHandler(
  ToggleRepairCompletionViewEvent event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    emit(state.copyWith(showCompleted: !state.showCompleted));
  }
}

/// Обработка добавления ремонта [AddRepairLocal].
///
/// Добавляет ремонт в список текущей опоры.
void onAddRepairHandler(
  AddRepairLocal event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final pole = state.poleList.first;
    final updatedRepairs = List<Repair>.from(pole.repairs)..add(event.repair);

    emit(state.copyWith(poleList: [pole.copyWith(repairs: updatedRepairs)]));
  }
}

/// Обработка удаления ремонта [DeleteRepairLocal].
///
/// Удаляет указанный ремонт из списка текущей опоры.
void onDeleteRepairHandler(
  DeleteRepairLocal event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final pole = state.poleList.first;
    final updatedRepairs = List<Repair>.from(pole.repairs)
      ..removeWhere((r) => r == event.repair);

    emit(state.copyWith(poleList: [pole.copyWith(repairs: updatedRepairs)]));
  }
}

/// Обработка события сохранения всех ремонтов [SubmitRepairs].
///
/// Отправляет обновлённую опору с ремонтами на сервер.
Future<void> onSubmitRepairsHandler(
  SubmitRepairs event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
  AbstractPoleRepositories poleRepositories,
) async {
  if (state is! RepairListLoaded) return;

  final authBloc = GetIt.I<AuthBloc>();
  String userName = 'Неизвестный пользователь';

  if (authBloc.state is Authenticated) {
    userName = (authBloc.state as Authenticated).user.name;
  }

  final poleToUpdate = state.poleList.first;

  emit(RepairListLoading());
  try {
    await poleRepositories.updatePole(
      poleToUpdate.id,
      number: poleToUpdate.number,
      repairs: poleToUpdate.repairs,
      check: true,
      userName: userName,
      lastCheckDate: formatDate(DateTime.now()),
    );

    GetIt.I<Talker>().debug(poleToUpdate);
    emit(RepairListLoaded(poleList: [poleToUpdate]));
  } catch (e, st) {
    emit(RepairListLoadingFailure(exception: e));
    GetIt.I<Talker>().handle(e, st);
  }
}

/// Обработка локального переключения статуса выполнения ремонта.
///
/// Меняет значение `completed` и дату завершения.
void onToggleRepairCompletedHandler(
  ToggleRepairCompletedLocal event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final pole = state.poleList.first;

    final updatedRepairs =
        pole.repairs.map((r) {
          if (r == event.repair) {
            return r.copyWith(
              completed: !r.completed,
              dateComplete: formatDate(DateTime.now()),
            );
          }
          return r;
        }).toList();

    emit(state.copyWith(poleList: [pole.copyWith(repairs: updatedRepairs)]));
  }
}

/// Обработка редактирования описания ремонта.
///
/// Обновляет поле [description] у соответствующего ремонта.
void onEditRepairHandler(
  EditRepairLocal event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final pole = state.poleList.first;

    final updatedRepairs =
        pole.repairs.map((r) {
          if (r == event.oldRepair) {
            return r.copyWith(description: event.newDescription);
          }
          return r;
        }).toList();

    emit(state.copyWith(poleList: [pole.copyWith(repairs: updatedRepairs)]));
  }
}
