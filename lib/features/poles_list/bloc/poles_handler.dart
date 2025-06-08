import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../../../repositories/poles_list_repo.dart/pole_list_repo.dart';
import 'poles_bloc.dart';

/// Загружает список опор из репозитория и сортирует их по номеру.
///
/// Если номер можно преобразовать в число, применяется числовая сортировка.
/// В случае ошибки — эмитится [PolesLoadingFailure], и в лог записывается исключение.
/// По завершении — вызывается [event.completer?.complete()].
Future<void> polesLoadingHandler(
  Emitter<PolesState> emit,
  LoadPoles event,
  AbstractPoleRepositories polesRepository,
) async {
  emit(PolesLoading());

  try {
    final poles = await polesRepository.fetchPoles();

    // Сортировка по числовому значению номера, если возможно.
    poles.sort((a, b) {
      final aNumber = int.tryParse(a.number);
      final bNumber = int.tryParse(b.number);

      if (aNumber == null && bNumber != null) return 1;
      if (aNumber != null && bNumber == null) return -1;
      if (aNumber == null && bNumber == null) {
        return a.number.compareTo(b.number);
      }

      return aNumber!.compareTo(bNumber!);
    });

    emit(PolesListLoaded(poles: poles, originalPoles: poles));
  } catch (e, st) {
    emit(PolesLoadingFailure(exception: e));
    GetIt.I<Talker>().handle(e, st);
  } finally {
    event.completer?.complete();
  }
}

/// Сортирует список опор по срочности ремонтов.
///
/// Срочные опоры (с пометкой `urgent == true`) выводятся первыми.
/// Если список уже отсортирован, происходит возврат к оригинальному порядку.
void sortPolesHandler(Emitter<PolesState> emit, PolesState state) {
  if (state is PolesListLoaded) {
    final loaded = state;

    if (loaded.isSorted) {
      // Сброс сортировки
      emit(
        PolesListLoaded(
          poles: loaded.originalPoles,
          originalPoles: loaded.originalPoles,
          isSorted: false,
        ),
      );
    } else {
      // Сортировка по срочности и номеру
      final sorted = List<Pole>.from(loaded.poles);
      sorted.sort((a, b) {
        final aUrgent = a.repairs.any((r) => r.urgent == true);
        final bUrgent = b.repairs.any((r) => r.urgent == true);

        if (aUrgent && !bUrgent) return -1;
        if (!aUrgent && bUrgent) return 1;

        final aNumber = int.tryParse(a.number);
        final bNumber = int.tryParse(b.number);

        if (aNumber != null && bNumber != null) {
          return aNumber.compareTo(bNumber);
        } else if (aNumber != null) {
          return -1;
        } else if (bNumber != null) {
          return 1;
        } else {
          return a.number.compareTo(b.number);
        }
      });

      emit(
        PolesListLoaded(
          poles: sorted,
          originalPoles: loaded.originalPoles,
          isSorted: true,
        ),
      );
    }
  }
}

/// Фильтрует список опор по номеру или описанию ремонта.
///
/// Поиск нечувствителен к регистру. Используется значение [event.query].
void searchPoleHandler(
  SearchPole event,
  Emitter<PolesState> emit,
  PolesState state,
) {
  if (state is PolesListLoaded) {
    final query = event.query.toLowerCase();

    final filtered =
        state.originalPoles.where((pole) {
          final numberMatch = pole.number.toLowerCase().contains(query);
          final repairMatch = pole.repairs.any(
            (repair) => repair.description.toLowerCase().contains(query),
          );
          return numberMatch || repairMatch;
        }).toList();

    emit(state.copyWith(poles: filtered));
  }
}

/// Сбрасывает отображаемый список опор к оригинальному (нефильтрованному и неотсортированному).
void resetPolesHandler(Emitter<PolesState> emit, PolesState state) {
  if (state is PolesListLoaded) {
    emit(
      PolesListLoaded(
        poles: List<Pole>.from(state.originalPoles),
        originalPoles: state.originalPoles,
      ),
    );
  }
}
