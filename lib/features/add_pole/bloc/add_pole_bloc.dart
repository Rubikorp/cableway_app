import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../repositories/poles_list_repo.dart/models/models.dart';
import '../../auth/auth.dart';
part 'add_pole_bloc_event.dart';
part 'add_pole_bloc_state.dart';

class AddPoleBloc extends Bloc<AddPoleBlocEvent, AddPoleBlocState> {
  final AbstractPoleRepositories polesRepository;

  AddPoleBloc(this.polesRepository) : super(const AddPoleLoaded()) {
    on<AddRepairPressed>((event, emit) {
      try {
        final currentState = state as AddPoleLoaded;
        final updatedRepairs = [...currentState.repairs, event.repair];
        emit(currentState.copyWith(repairs: updatedRepairs));
      } catch (e, st) {
        GetIt.instance<Talker>().handle(e, st);
      }
    });

    on<LoadAddPole>((event, emit) async {
      if (state is! AddPoleLoaded) return;

      final currentState = state as AddPoleLoaded;

      // Получаем имя пользователя через GetIt
      final authBloc = GetIt.I<AuthBloc>();
      var userName = 'Неизвестный пользователь';
      final stateAuth = authBloc.state;
      if (stateAuth is Authenticated) {
        userName = stateAuth.user.name;
      }
      emit(AddPoleLoading());
      try {
        await polesRepository.addPole(
          PoleAdd(
            number: event.number,
            repairs: currentState.repairs,
            check: true,
            userName: userName,
          ),
        );
      } catch (e, st) {
        emit(AddPoleLoadingFailure(exception: e) as AddPoleLoaded);
        GetIt.instance<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
      }
    });

    on<ResetAddPoleState>((event, emit) {
      emit(const AddPoleLoaded()); // или emit(state.copyWith(error: null));
    });
  }
}
