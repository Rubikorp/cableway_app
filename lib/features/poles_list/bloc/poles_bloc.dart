import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/models/pole_model.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'poles_event.dart';
part 'poles_state.dart';

class PolesBloc extends Bloc<PolesEvent, PolesState> {
  PolesBloc(this.polesRepository) : super(PolesInitial()) {
    on<LoadPoles>((event, emit) async {
      emit(PolesLoading());
      try {
        final poles = await polesRepository.fetchPoles();
        emit(PolesListLoaded(poles: poles, originalPoles: poles));
      } catch (e, st) {
        emit(PolesLoadingFailure(exception: e));
        GetIt.instance<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });

    on<SortPoles>((event, emit) {
      if (state is PolesListLoaded) {
        final loadedState = state as PolesListLoaded;
        final poles = List<Pole>.from((state as PolesListLoaded).poles);

        poles.sort((a, b) {
          final aIsNumber = int.tryParse(a.number);
          final bIsNumber = int.tryParse(b.number);

          // 1. Опоры с именами в конец
          if (aIsNumber == null && bIsNumber != null) return 1;
          if (aIsNumber != null && bIsNumber == null) return -1;
          if (aIsNumber == null && bIsNumber == null) {
            return a.number.compareTo(b.number);
          }

          // 2. Приоритетные (непроверенные) в начало
          if ((a.check != true) && (b.check == true)) return -1;
          if ((a.check == true) && (b.check != true)) return 1;

          // 3. По номеру (если оба — числа)
          return aIsNumber!.compareTo(bIsNumber!);
        });

        emit(
          PolesListLoaded(
            poles: poles,
            originalPoles: loadedState.originalPoles,
          ),
        );
      }
    });

    on<SearchPole>((event, emit) {
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
    });

    on<ResetPoles>((event, emit) {
      if (state is PolesListLoaded) {
        final currentState = state as PolesListLoaded;
        emit(
          PolesListLoaded(
            poles: List<Pole>.from(currentState.originalPoles),
            originalPoles: currentState.originalPoles,
          ),
        );
      }
    });
  }

  @override //ловит ошибки только вне блока try catch
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }

  final AbstractPoleRepositories polesRepository;
}
