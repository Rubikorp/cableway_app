import 'package:bloc/bloc.dart';
import 'package:cable_road_project/features/repair_list/bloc/repair_list_bloc_handlers.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../repositories/poles_list_repo.dart/models/models.dart';

part 'repair_list_bloc_event.dart';
part 'repair_list_bloc_state.dart';

/// BLoC для управления списком ремонтов опор.
///
/// Отвечает за загрузку списка ремонтов и переключение вида (все/только завершённые).
class RepairListBlocBloc
    extends Bloc<RepairListBlocEvent, RepairListBlocState> {
  /// Репозиторий для получения данных об опорах.
  final AbstractPoleRepositories poleRepositories;

  /// Конструктор [RepairListBlocBloc].
  ///
  /// Подписывается на события [LoadRepairList] и [ToggleRepairCompletionViewEvent].
  RepairListBlocBloc(this.poleRepositories) : super(RepairListInitial()) {
    on<LoadRepairList>((event, emit) => onLoadRepairListHandler(event, emit));
    on<ToggleRepairCompletionViewEvent>(
      (event, emit) => onToggleViewHandler(event, emit, state),
    );
    on<AddRepairLocal>((event, emit) => onAddRepairHandler(event, emit, state));
    on<DeleteRepairLocal>(
      (event, emit) => onDeleteRepairHandler(event, emit, state),
    );
    on<SubmitRepairs>(
      (event, emit) =>
          onSubmitRepairsHandler(event, emit, state, poleRepositories),
    );
    on<ToggleRepairCompletedLocal>(
      (event, emit) => onToggleRepairCompletedHandler(event, emit, state),
    );
    on<EditRepairLocal>(
      (event, emit) => onEditRepairHandler(event, emit, state),
    );
  }

  /// Обработка необработанных ошибок внутри BLoC.
  ///
  /// Логирует ошибку через [Talker].
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
