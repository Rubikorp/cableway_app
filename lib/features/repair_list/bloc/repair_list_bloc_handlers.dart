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

    final pole = event.pole; // Repairs уже внутри переданной опоры
    emit(RepairListLoaded(poleList: [pole]));
  } catch (e, st) {
    emit(RepairListLoadingFailure(exception: e));
    GetIt.I<Talker>().handle(e, st);
  }
}

/// Обработка события переключения отображения завершённых ремонтов.
///
/// Изменяет флаг [showCompleted] в состоянии [RepairListLoaded].
void onToggleViewHandler(
  ToggleRepairCompletionViewEvent event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final current = state;
    emit(current.copyWith(showCompleted: !current.showCompleted));
  }
}

void onAddRepairHandler(
  AddRepairLocal event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final current = state;
    final updatedPole = current.poleList.first;

    final updatedRepairs = List<Repair>.from(updatedPole.repairs)
      ..add(event.repair);

    final updatedPoleWithNewRepairs = updatedPole.copyWith(
      repairs: updatedRepairs,
    );

    emit(current.copyWith(poleList: [updatedPoleWithNewRepairs]));
  }
}

void onDeleteRepairHandler(
  DeleteRepairLocal event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final current = state;
    final updatedPole = current.poleList.first;

    final updatedRepairs = List<Repair>.from(updatedPole.repairs)
      ..removeWhere((r) => r == event.repair);

    final updatedPoleWithNewRepairs = updatedPole.copyWith(
      repairs: updatedRepairs,
    );

    emit(current.copyWith(poleList: [updatedPoleWithNewRepairs]));
  }
}

Future<void> onSubmitRepairsHandler(
  SubmitRepairs event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
  AbstractPoleRepositories poleRepositories,
) async {
  final authBloc = GetIt.I<AuthBloc>();
  var userName = 'Неизвестный пользователь';
  final stateAuth = authBloc.state;
  if (stateAuth is Authenticated) {
    userName = stateAuth.user.name;
  }

  if (state is RepairListLoaded) {
    final current = state;
    final poleToUpdate = current.poleList.first;

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
}

void onToggleRepairCompletedHandler(
  ToggleRepairCompletedLocal event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final current = state;
    final pole = current.poleList.first;

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

    emit(current.copyWith(poleList: [pole.copyWith(repairs: updatedRepairs)]));
  }
}

void onEditRepairHandler(
  EditRepairLocal event,
  Emitter<RepairListBlocState> emit,
  RepairListBlocState state,
) {
  if (state is RepairListLoaded) {
    final current = state;
    final pole = current.poleList.first;

    final updatedRepairs =
        pole.repairs.map((r) {
          if (r == event.oldRepair) {
            return r.copyWith(description: event.newDescription);
          }
          return r;
        }).toList();

    emit(current.copyWith(poleList: [pole.copyWith(repairs: updatedRepairs)]));
  }
}
