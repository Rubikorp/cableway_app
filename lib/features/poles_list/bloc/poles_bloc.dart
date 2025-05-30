import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/pole_model.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'poles_event.dart';
part 'poles_state.dart';

/// BLoC для управления состоянием списка опор.
///
/// Обрабатывает загрузку, сортировку, поиск и сброс состояния.
/// Использует [AbstractPoleRepositories] для получения данных.
class PolesBloc extends Bloc<PolesEvent, PolesState> {
  /// Репозиторий для получения данных об опорах.
  final AbstractPoleRepositories polesRepository;

  /// Создает экземпляр [PolesBloc] с переданным [polesRepository].
  PolesBloc(this.polesRepository) : super(PolesInitial()) {
    // Загрузка опор из API или локального хранилища
    on<LoadPoles>((event, emit) async {
      await _polesLoading(emit, event);
    });

    // Сортировка списка опор по приоритету
    on<SortPoles>((event, emit) {
      _sortPoles(emit);
    });

    // Поиск опор по номеру или описанию ремонта
    on<SearchPole>((event, emit) {
      _searchPole(event, emit);
    });

    // Сброс отфильтрованного списка к оригинальному
    on<ResetPoles>((event, emit) {
      _resetPoles(emit);
    });

    on<DeletePole>((event, emit) async {
      try {
        await polesRepository.deletePole(event.deletePoleId);
      } catch (e, st) {
        GetIt.instance<Talker>().handle(e, st);
      }
    });
  }

  /// Загружает список опор из репозитория и сортирует их по номеру.
  ///
  /// Если номер можно преобразовать в число, используется числовая сортировка.
  /// В случае ошибки — возвращается кэшированный список.
  Future<void> _polesLoading(Emitter<PolesState> emit, LoadPoles event) async {
    emit(PolesLoading());
    try {
      final poles = await polesRepository.fetchPoles();
      poles.sort((a, b) {
        final aIsNumber = int.tryParse(a.number);
        final bIsNumber = int.tryParse(b.number);

        if (aIsNumber == null && bIsNumber != null) return 1;
        if (aIsNumber != null && bIsNumber == null) return -1;
        if (aIsNumber == null && bIsNumber == null) {
          return a.number.compareTo(b.number);
        }
        return aIsNumber!.compareTo(bIsNumber!);
      });
      emit(PolesListLoaded(poles: poles, originalPoles: poles));
    } catch (e, st) {
      emit(PolesLoadingFailure(exception: e));
      GetIt.instance<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  /// Сортирует список опор по срочности ремонтов.
  ///
  /// Срочные опоры идут первыми. Если список уже отсортирован —
  /// возвращается оригинальный порядок.
  void _sortPoles(Emitter<PolesState> emit) {
    if (state is PolesListLoaded) {
      final loadedState = state as PolesListLoaded;

      if (loadedState.isSorted) {
        emit(
          PolesListLoaded(
            poles: loadedState.originalPoles,
            originalPoles: loadedState.originalPoles,
            isSorted: false,
          ),
        );
      } else {
        final sortedPoles = List<Pole>.from(loadedState.poles);

        sortedPoles.sort((a, b) {
          final aUrgent = a.repairs.any((r) => r.urgent == true);
          final bUrgent = b.repairs.any((r) => r.urgent == true);

          if (aUrgent && !bUrgent) return -1;
          if (!aUrgent && bUrgent) return 1;

          final aIsNumber = int.tryParse(a.number);
          final bIsNumber = int.tryParse(b.number);

          if (aIsNumber != null && bIsNumber != null) {
            return aIsNumber.compareTo(bIsNumber);
          } else if (aIsNumber != null) {
            return -1;
          } else if (bIsNumber != null) {
            return 1;
          } else {
            return a.number.compareTo(b.number);
          }
        });

        emit(
          PolesListLoaded(
            poles: sortedPoles,
            originalPoles: loadedState.originalPoles,
            isSorted: true,
          ),
        );
      }
    }
  }

  /// Фильтрует список опор по номеру или описанию ремонта.
  ///
  /// [event.query] используется для фильтрации, регистр не учитывается.
  void _searchPole(SearchPole event, Emitter<PolesState> emit) {
    final currentState = state;
    if (currentState is PolesListLoaded) {
      final query = event.query.toLowerCase();
      final filtered =
          currentState.originalPoles.where((pole) {
            final numberMatches = pole.number.toLowerCase().contains(query);
            final repairMatches = pole.repairs.any(
              (repair) => repair.description.toLowerCase().contains(query),
            );
            return numberMatches || repairMatches;
          }).toList();

      emit(currentState.copyWith(poles: filtered));
    }
  }

  /// Сбрасывает список опор к оригинальному состоянию.
  void _resetPoles(Emitter<PolesState> emit) {
    if (state is PolesListLoaded) {
      final currentState = state as PolesListLoaded;
      emit(
        PolesListLoaded(
          poles: List<Pole>.from(currentState.originalPoles),
          originalPoles: currentState.originalPoles,
        ),
      );
    }
  }

  /// Обработка необработанных ошибок в блоке.
  ///
  /// Работает только для ошибок вне `try/catch`.
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
