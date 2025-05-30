part of 'add_pole_bloc.dart';

abstract class AddPoleBlocState extends Equatable {
  const AddPoleBlocState();
}

class AddPoleInitial extends AddPoleBlocState {
  @override
  List<Object?> get props => [];
}

class AddPoleLoaded extends AddPoleBlocState {
  final String name;
  final List<Repair> repairs;

  const AddPoleLoaded({this.name = '', this.repairs = const []});

  AddPoleLoaded copyWith({String? name, List<Repair>? repairs}) {
    return AddPoleLoaded(
      name: name ?? this.name,
      repairs: repairs ?? this.repairs,
    );
  }

  @override
  List<Object?> get props => [name, repairs];
}

class AddPoleLoadingFailure extends AddPoleBlocState {
  final Object? exception;

  const AddPoleLoadingFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}

class AddPoleLoading extends AddPoleBlocState {
  @override
  List<Object?> get props => [];
}
