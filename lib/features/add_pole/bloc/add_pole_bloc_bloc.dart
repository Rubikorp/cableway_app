import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_pole_bloc_event.dart';
part 'add_pole_bloc_state.dart';

class AddPoleBlocBloc extends Bloc<AddPoleBlocEvent, AddPoleBlocState> {
  AddPoleBlocBloc() : super(AddPoleBlocInitial()) {
    on<AddPoleBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
