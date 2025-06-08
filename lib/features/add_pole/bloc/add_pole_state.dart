part of 'add_pole_bloc.dart';

/// Абстрактное базовое состояние для [AddPoleBloc].
///
/// Используется как основа для конкретных состояний:
/// - [AddPoleInitial]
/// - [AddPoleLoaded]
/// - [AddPoleLoading]
/// - [AddPoleLoadingFailure]
abstract class AddPoleBlocState extends Equatable {
  const AddPoleBlocState();
}

/// Начальное состояние при запуске BLoC.
///
/// Может использоваться, если нужно явно указать, что ничего не загружено.
class AddPoleInitial extends AddPoleBlocState {
  @override
  List<Object?> get props => [];
}

/// Состояние, при котором данные для добавления опоры загружены и доступны.
///
/// Содержит:
/// - [name] — имя или номер опоры (по умолчанию пустая строка);
/// - [repairs] — список текущих ремонтов.
class AddPoleLoaded extends AddPoleBlocState {
  final String name;
  final List<Repair> repairs;

  const AddPoleLoaded({this.name = '', this.repairs = const []});

  /// Возвращает копию текущего состояния с обновлёнными полями.
  AddPoleLoaded copyWith({String? name, List<Repair>? repairs}) {
    return AddPoleLoaded(
      name: name ?? this.name,
      repairs: repairs ?? this.repairs,
    );
  }

  @override
  List<Object?> get props => [name, repairs];
}

/// Состояние, когда происходит загрузка (например, отправка данных на сервер).
class AddPoleLoading extends AddPoleBlocState {
  @override
  List<Object?> get props => [];
}

/// Состояние ошибки при добавлении опоры.
///
/// Содержит объект [exception], который можно логировать или отображать в UI.
class AddPoleLoadingFailure extends AddPoleBlocState {
  final Object? exception;

  const AddPoleLoadingFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}
