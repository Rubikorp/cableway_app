part of 'poles_bloc.dart';

abstract class PolesState extends Equatable {}

class PolesInitial extends PolesState {
  @override
  List<Object?> get props => [];
}

class PolesLoading extends PolesState {
  @override
  List<Object?> get props => [];
}

class PolesListLoaded extends PolesState {
  final List<Pole> poles;

  PolesListLoaded({required this.poles});

  @override
  List<Object?> get props => [poles];
}

class PolesLoadingFailure extends PolesState {
  final Object? exception;

  PolesLoadingFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}
