import 'package:bloc/bloc.dart';
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
    on<LoadRepairList>(_onLoadRepairList);
    on<ToggleRepairCompletionViewEvent>(_onToggleView);
  }

  /// Обработка события загрузки списка ремонтов [LoadRepairList].
  ///
  /// Использует переданную опору [event.pole], не делает повторный запрос в репозиторий.
  Future<void> _onLoadRepairList(
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
  void _onToggleView(
    ToggleRepairCompletionViewEvent event,
    Emitter<RepairListBlocState> emit,
  ) {
    if (state is RepairListLoaded) {
      final current = state as RepairListLoaded;
      emit(current.copyWith(showCompleted: !current.showCompleted));
    }
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
