part of 'add_pole_bloc_bloc.dart';

abstract class AddPoleBlocState extends Equatable {
  const AddPoleBlocState();
}

class AddPoleBlocInitial extends AddPoleBlocState {
  final String name;
  final List<Repair> repairs;
  final bool isLoading;
  final String? error;

  const AddPoleBlocInitial({
    this.name = '',
    this.repairs = const [],
    this.isLoading = false,
    this.error,
  });

  AddPoleBlocInitial copyWith({
    String? name,
    List<Repair>? repairs,
    bool? isLoading,
    String? error,
  }) {
    return AddPoleBlocInitial(
      name: name ?? this.name,
      repairs: repairs ?? this.repairs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [name, repairs, isLoading, error];
}
