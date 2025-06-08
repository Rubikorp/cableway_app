import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/pole_model.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'poles_handler.dart';

part 'poles_event.dart';
part 'poles_state.dart';

/// BLoC для управления состоянием списка опор.
///
/// Отвечает за загрузку, сортировку, поиск, сброс и удаление опор.
/// Использует [AbstractPoleRepositories] для получения и изменения данных.
class PolesBloc extends Bloc<PolesEvent, PolesState> {
  /// Репозиторий для взаимодействия с данными опор.
  final AbstractPoleRepositories polesRepository;

  /// Создает экземпляр [PolesBloc] с переданным [polesRepository].
  PolesBloc(this.polesRepository) : super(PolesInitial()) {
    // Загрузка опор из API или локального хранилища.
    on<LoadPoles>((event, emit) async {
      await polesLoadingHandler(emit, event, polesRepository);
    });

    // Сортировка списка опор по срочности и номеру.
    on<SortPoles>((event, emit) {
      sortPolesHandler(emit, state);
    });

    // Поиск опор по номеру или описанию ремонта.
    on<SearchPole>((event, emit) {
      searchPoleHandler(event, emit, state);
    });

    // Сброс фильтрации и сортировки к исходному состоянию.
    on<ResetPoles>((event, emit) {
      resetPolesHandler(emit, state);
    });

    // Удаление опоры по ID.
    on<DeletePole>((event, emit) async {
      emit(DeletePoleLoading());
      try {
        await polesRepository.deletePole(event.deletePoleId);
        emit(DeletedPoleLoaded());
      } catch (e, st) {
        emit(DeletePoleFailure(exception: e));
        GetIt.instance<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });
  }

  /// Обработка глобальных ошибок в BLoC.
  ///
  /// Срабатывает только для необработанных исключений вне `try/catch`.
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
