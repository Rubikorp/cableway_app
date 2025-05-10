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
      try {
        if (state is! PolesListLoaded) {
          emit(PolesLoading());
        }

        final polesList = await polesRepository.fetchPoles();
        emit(PolesListLoaded(poles: polesList));
      } catch (e, st) {
        emit(PolesLoadingFailure(exception: e));
        GetIt.instance<Talker>().handle(e, st);
      } finally {
        event.completer?.complete();
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
