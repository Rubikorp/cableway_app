part of 'poles_bloc.dart';

abstract class PolesEvent extends Equatable {}

class LoadPoles extends PolesEvent {
  LoadPoles({this.completer});

  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}
