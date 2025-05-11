part of 'poles_bloc.dart';

abstract class PolesEvent extends Equatable {}

class LoadPoles extends PolesEvent {
  LoadPoles({this.completer});

  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class SortPoles extends PolesEvent {
  @override
  List<Object?> get props => [];
}

class SearchPole extends PolesEvent {
  final String query;

  SearchPole({required this.query});

  @override
  List<Object?> get props => [query];
}

class ResetPoles extends PolesEvent {
  @override
  List<Object?> get props => [];
}
