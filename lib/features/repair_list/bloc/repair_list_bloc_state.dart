part of 'repair_list_bloc_bloc.dart';

abstract class RepairListBlocState extends Equatable {}

class RepairListInitial extends RepairListBlocState {
  @override
  List<Object?> get props => [];
}

class RepairListLoading extends RepairListBlocState {
  @override
  List<Object?> get props => [];
}

class RepairListLoaded extends RepairListBlocState {
  final List<Pole> poleList;
  final bool showCompleted;

  RepairListLoaded({required this.poleList, this.showCompleted = false});

  @override
  List<Object?> get props => [poleList, showCompleted];

  RepairListLoaded copyWith({List<Pole>? poleList, bool? showCompleted}) {
    return RepairListLoaded(
      poleList: poleList ?? this.poleList,
      showCompleted: showCompleted ?? this.showCompleted,
    );
  }
}

class RepairListLoadingFailure extends RepairListBlocState {
  final Object? exception;

  RepairListLoadingFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}
