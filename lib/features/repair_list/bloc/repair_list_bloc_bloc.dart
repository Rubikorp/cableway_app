import 'package:bloc/bloc.dart';
import 'package:cable_road_project/features/repair_list/bloc/repair_list_bloc_handlers.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../repositories/poles_list_repo.dart/models/models.dart';

part 'repair_list_bloc_event.dart';
part 'repair_list_bloc_state.dart';

/// BLoC для управления списком ремонтов опоры.
///
/// Обрабатывает загрузку, локальное добавление/удаление/редактирование ремонтов,
/// переключение отображения завершённых, отправку данных на сервер.
class RepairListBlocBloc
    extends Bloc<RepairListBlocEvent, RepairListBlocState> {
  /// Репозиторий для работы с опорами.
  final AbstractPoleRepositories poleRepositories;

  /// Конструктор [RepairListBlocBloc].
  ///
  /// Регистрирует обработчики всех возможных событий.
  RepairListBlocBloc(this.poleRepositories) : super(RepairListInitial()) {
    on<LoadRepairList>(_onLoadRepairList);
    on<ToggleRepairCompletionViewEvent>(_onToggleView);
    on<AddRepairLocal>(_onAddRepair);
    on<DeleteRepairLocal>(_onDeleteRepair);
    on<EditRepairLocal>(_onEditRepair);
    on<ToggleRepairCompletedLocal>(_onToggleRepairCompleted);
    on<SubmitRepairs>(_onSubmitRepairs);
  }

  /// Обработка события загрузки списка ремонтов.
  Future<void> _onLoadRepairList(
    LoadRepairList event,
    Emitter<RepairListBlocState> emit,
  ) => onLoadRepairListHandler(event, emit);

  /// Обработка события переключения отображения завершённых ремонтов.
  void _onToggleView(
    ToggleRepairCompletionViewEvent event,
    Emitter<RepairListBlocState> emit,
  ) => onToggleViewHandler(event, emit, state);

  /// Обработка добавления нового ремонта.
  void _onAddRepair(AddRepairLocal event, Emitter<RepairListBlocState> emit) =>
      onAddRepairHandler(event, emit, state);

  /// Обработка удаления ремонта.
  void _onDeleteRepair(
    DeleteRepairLocal event,
    Emitter<RepairListBlocState> emit,
  ) => onDeleteRepairHandler(event, emit, state);

  /// Обработка редактирования ремонта.
  void _onEditRepair(
    EditRepairLocal event,
    Emitter<RepairListBlocState> emit,
  ) => onEditRepairHandler(event, emit, state);

  /// Обработка переключения статуса выполнения ремонта.
  void _onToggleRepairCompleted(
    ToggleRepairCompletedLocal event,
    Emitter<RepairListBlocState> emit,
  ) => onToggleRepairCompletedHandler(event, emit, state);

  /// Обработка отправки списка ремонтов на сервер.
  Future<void> _onSubmitRepairs(
    SubmitRepairs event,
    Emitter<RepairListBlocState> emit,
  ) => onSubmitRepairsHandler(event, emit, state, poleRepositories);

  /// Обработка необработанных ошибок внутри BLoC.
  ///
  /// Логирует ошибку через [Talker].
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
