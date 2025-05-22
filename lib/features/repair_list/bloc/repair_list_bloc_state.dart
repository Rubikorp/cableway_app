part of 'repair_list_bloc_bloc.dart';

/// Абстрактное состояние BLoC для списка ремонтов.
///
/// Все состояния, связанные с отображением, загрузкой и ошибками в [RepairListBlocBloc],
/// должны наследоваться от этого класса.
abstract class RepairListBlocState extends Equatable {}

/// Начальное состояние перед любой загрузкой.
///
/// Используется сразу после создания BLoC.
class RepairListInitial extends RepairListBlocState {
  @override
  List<Object?> get props => [];
}

/// Состояние загрузки списка ремонтов.
///
/// Используется при начале запроса данных.
class RepairListLoading extends RepairListBlocState {
  @override
  List<Object?> get props => [];
}

/// Состояние успешной загрузки списка ремонтов.
///
/// [poleList] — список опор с их ремонтами.
/// [showCompleted] — флаг, указывающий, отображаются ли завершённые ремонты.
class RepairListLoaded extends RepairListBlocState {
  /// Список опор с ремонтами.
  final List<Pole> poleList;

  /// Флаг отображения завершённых ремонтов.
  final bool showCompleted;

  /// Конструктор состояния [RepairListLoaded].
  RepairListLoaded({required this.poleList, this.showCompleted = false});

  @override
  List<Object?> get props => [poleList, showCompleted];

  /// Создаёт копию текущего состояния с возможностью изменить поля.
  RepairListLoaded copyWith({List<Pole>? poleList, bool? showCompleted}) {
    return RepairListLoaded(
      poleList: poleList ?? this.poleList,
      showCompleted: showCompleted ?? this.showCompleted,
    );
  }
}

/// Состояние ошибки при загрузке списка ремонтов.
///
/// [exception] — объект ошибки, если он доступен.
class RepairListLoadingFailure extends RepairListBlocState {
  /// Исключение, возникшее при загрузке.
  final Object? exception;

  /// Конструктор состояния ошибки [RepairListLoadingFailure].
  RepairListLoadingFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}
