import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../repositories/poles_list_repo.dart/models/models.dart';

part 'repair_list_bloc_event.dart';
part 'repair_list_bloc_state.dart';

class RepairListBlocBloc
    extends Bloc<RepairListBlocEvent, RepairListBlocState> {
  final AbstractPoleRepositories poleRepositories;

  RepairListBlocBloc(this.poleRepositories) : super(RepairListInitial()) {
    on<LoadRepairList>(_onLoadRepairList);
    on<ToggleRepairCompletionViewEvent>(_onToggleView);
  }

  Future<void> _onLoadRepairList(
    LoadRepairList event,
    Emitter<RepairListBlocState> emit,
  ) async {
    try {
      emit(RepairListLoading());

      // Так как pole уже передан и repairs внутри него — не грузим из репозитория
      final pole = event.pole;

      emit(RepairListLoaded(poleList: [pole]));
    } catch (e, st) {
      emit(RepairListLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  void _onToggleView(
    ToggleRepairCompletionViewEvent event,
    Emitter<RepairListBlocState> emit,
  ) {
    if (state is RepairListLoaded) {
      final current = state as RepairListLoaded;
      emit(current.copyWith(showCompleted: !current.showCompleted));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
