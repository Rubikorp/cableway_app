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
  final List<Pole> originalPoles;
  final bool isSorted;

  PolesListLoaded({
    required this.poles,
    required this.originalPoles,
    this.isSorted = false,
  });

  PolesListLoaded copyWith({List<Pole>? poles, List<Pole>? originalPoles}) {
    return PolesListLoaded(
      poles: poles ?? this.poles,
      originalPoles: originalPoles ?? this.originalPoles,
    );
  }

  @override
  List<Object?> get props => [poles, originalPoles, isSorted];
}

class PolesLoadingFailure extends PolesState {
  final Object? exception;

  PolesLoadingFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}
