part of 'repair_list_bloc_bloc.dart';

abstract class RepairListBlocEvent extends Equatable {}

class LoadRepairList extends RepairListBlocEvent {
  final Pole pole;

  LoadRepairList({required this.pole});

  @override
  List<Object?> get props => [pole];
}

class ToggleRepairCompletionViewEvent extends RepairListBlocEvent {
  @override
  List<Object?> get props => [];
}
