import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';

import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../../auth/auth.dart';
import 'add_pole_handler.dart';

part 'add_pole_event.dart';
part 'add_pole_state.dart';

/// BLoC для управления логикой добавления новой опоры и ремонтов к ней.
///
/// Обрабатывает события:
/// - [AddRepairPressed] — добавление ремонта к опоре.
/// - [LoadAddPole] — сохранение новой опоры на сервер.
/// - [ResetAddPoleState] — сброс состояния формы добавления.
///
/// Использует репозиторий [AbstractPoleRepositories] для взаимодействия с API,
/// а также получает имя пользователя через [AuthBloc] с помощью [GetIt].
class AddPoleBloc extends Bloc<AddPoleBlocEvent, AddPoleBlocState> {
  /// Репозиторий для операций над опорами.
  final AbstractPoleRepositories polesRepository;

  /// Конструктор BLoC. Принимает репозиторий опор.
  ///
  /// Начальное состояние — [AddPoleLoaded] с пустым списком ремонтов.
  AddPoleBloc(this.polesRepository) : super(const AddPoleLoaded()) {
    /// Обработчик события добавления ремонта.
    on<AddRepairPressed>((event, emit) {
      onAddRepairHandler(event, emit, state);
    });

    /// Обработчик события сохранения новой опоры.
    on<LoadAddPole>((event, emit) async {
      // Проверяем, что текущее состояние поддерживает сохранение
      if (state is! AddPoleLoaded) return;
      final currentState = state as AddPoleLoaded;

      // Получаем имя пользователя через AuthBloc, зарегистрированный в GetIt
      final authBloc = GetIt.I<AuthBloc>();
      var userName = 'Неизвестный пользователь';
      final stateAuth = authBloc.state;
      if (stateAuth is Authenticated) {
        userName = stateAuth.user.name;
      }

      // Эмитим состояние загрузки перед сохранением
      emit(AddPoleLoading());

      // Выполняем сохранение опоры через репозиторий
      await onLoadAddPoleHundler(
        event,
        currentState,
        userName,
        emit,
        polesRepository,
      );
    });

    /// Обработчик события сброса состояния (например, при очистке формы).
    on<ResetAddPoleState>((event, emit) {
      emit(const AddPoleLoaded());
    });
  }
}
