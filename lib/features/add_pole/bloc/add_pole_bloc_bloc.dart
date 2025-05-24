import 'package:bloc/bloc.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/pole_model.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/repairs_model.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../auth/auth.dart';
import '../../poles_list/bloc/poles_bloc.dart';

part 'add_pole_bloc_event.dart';
part 'add_pole_bloc_state.dart';

class AddPoleBloc extends Bloc<AddPoleBlocEvent, AddPoleBlocInitial> {
  final AbstractPoleRepositories repo;

  AddPoleBloc(this.repo) : super(const AddPoleBlocInitial()) {
    on<AddPoleNameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<AddRepairPressed>((event, emit) {
      final updatedRepairs = [...state.repairs, event.repair];
      emit(state.copyWith(repairs: updatedRepairs));
    });

    on<SubmitPolePressed>((event, emit) async {
      final _polesListBloc = PolesBloc(GetIt.I<AbstractPoleRepositories>());
      if (state.name.trim().isEmpty) {
        emit(state.copyWith(error: 'Название опоры обязательно'));
        return;
      }

      emit(state.copyWith(isLoading: true, error: null));

      // Получаем имя пользователя через GetIt
      final authBloc = GetIt.I<AuthBloc>();
      var userName = 'Неизвестный пользователь';
      final stateAuth = authBloc.state;
      if (stateAuth is Authenticated) {
        userName = stateAuth.user.name;
      }

      final success = await repo.addPole(
        Pole(
          number: state.name,
          repairs: state.repairs,
          check: true,
          userName: userName,
        ),
      );

      if (success) {
        emit(const AddPoleBlocInitial());
        _polesListBloc.add(LoadPoles());
      } else {
        emit(state.copyWith(isLoading: false, error: 'Ошибка при добавлении'));
      }
    });

    on<ResetAddPoleState>((event, emit) {
      emit(
        const AddPoleBlocInitial(),
      ); // или emit(state.copyWith(error: null));
    });
  }
}
