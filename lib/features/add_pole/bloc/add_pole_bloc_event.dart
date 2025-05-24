part of 'add_pole_bloc_bloc.dart';

abstract class AddPoleBlocEvent extends Equatable {
  const AddPoleBlocEvent();
}

class AddPoleNameChanged extends AddPoleBlocEvent {
  final String name;

  const AddPoleNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class AddRepairPressed extends AddPoleBlocEvent {
  final Repair repair;

  const AddRepairPressed(this.repair);

  @override
  List<Object?> get props => [repair];
}

class SubmitPolePressed extends AddPoleBlocEvent {
  const SubmitPolePressed();

  @override
  List<Object?> get props => [];
}

class ResetAddPoleState extends AddPoleBlocEvent {
  @override
  List<Object?> get props => [];
}
