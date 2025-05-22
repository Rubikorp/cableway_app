part of 'poles_bloc.dart';

/// Абстрактный базовый класс состояний для [PolesBloc].
abstract class PolesState extends Equatable {}

/// Начальное состояние перед загрузкой опор.
class PolesInitial extends PolesState {
  @override
  List<Object?> get props => [];
}

/// Состояние загрузки списка опор.
class PolesLoading extends PolesState {
  @override
  List<Object?> get props => [];
}

/// Состояние, в котором список опор успешно загружен.
///
/// [poles] — текущий (возможно, отфильтрованный или отсортированный) список.
/// [originalPoles] — оригинальный, несортированный и нефильтрованный список.
/// [isSorted] — индикатор, отсортирован ли текущий список по важности/номеру.
class PolesListLoaded extends PolesState {
  /// Текущий список отображаемых опор.
  final List<Pole> poles;

  /// Оригинальный список опор до сортировки и фильтрации.
  final List<Pole> originalPoles;

  /// Флаг, указывающий, применена ли сортировка.
  final bool isSorted;

  /// Создает состояние с загруженным списком опор.
  PolesListLoaded({
    required this.poles,
    required this.originalPoles,
    this.isSorted = false,
  });

  /// Создает копию текущего состояния с обновленными значениями.
  PolesListLoaded copyWith({List<Pole>? poles, List<Pole>? originalPoles}) {
    return PolesListLoaded(
      poles: poles ?? this.poles,
      originalPoles: originalPoles ?? this.originalPoles,
    );
  }

  @override
  List<Object?> get props => [poles, originalPoles, isSorted];
}

/// Состояние ошибки при загрузке опор.
///
/// [exception] содержит выброшенное исключение.
class PolesLoadingFailure extends PolesState {
  /// Исключение, возникшее при загрузке.
  final Object? exception;

  /// Создает состояние ошибки загрузки.
  PolesLoadingFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}
