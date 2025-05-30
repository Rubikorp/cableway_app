part of 'add_pole_bloc.dart';

abstract class AddPoleBlocEvent extends Equatable {
  const AddPoleBlocEvent();
}

class LoadAddPole extends AddPoleBlocEvent {
  final Completer? completer;
  final String number;

  const LoadAddPole({this.completer, required this.number});

  @override
  List<Object?> get props => [completer, number];
}

class AddRepairPressed extends AddPoleBlocEvent {
  final Repair repair;

  const AddRepairPressed(this.repair);

  @override
  List<Object?> get props => [repair];
}

class ResetAddPoleState extends AddPoleBlocEvent {
  @override
  List<Object?> get props => [];
}
