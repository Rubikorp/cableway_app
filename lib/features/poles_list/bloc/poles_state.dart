part of 'poles_bloc.dart';

/// Абстрактный базовый класс состояний для [PolesBloc].
///
/// Используется для представления различных состояний UI при работе с опорами.
abstract class PolesState extends Equatable {}

/// Начальное состояние перед загрузкой опор.
///
/// Обычно устанавливается при запуске приложения или сбросе состояния.
class PolesInitial extends PolesState {
  @override
  List<Object?> get props => [];
}

/// Состояние загрузки списка опор.
///
/// Показывает индикатор загрузки на экране.
class PolesLoading extends PolesState {
  @override
  List<Object?> get props => [];
}

/// Состояние, в котором список опор успешно загружен.
///
/// - [poles] — текущий (возможно, отфильтрованный или отсортированный) список.
/// - [originalPoles] — оригинальный список до сортировки и фильтрации.
/// - [isSorted] — флаг, указывающий, применена ли сортировка.
class PolesListLoaded extends PolesState {
  /// Отображаемый список опор.
  final List<Pole> poles;

  /// Оригинальный, неотфильтрованный список.
  final List<Pole> originalPoles;

  /// Флаг, указывающий, применена ли сортировка.
  final bool isSorted;

  /// Создает состояние [PolesListLoaded].
  PolesListLoaded({
    required this.poles,
    required this.originalPoles,
    this.isSorted = false,
  });

  /// Создает копию текущего состояния с обновлёнными значениями.
  PolesListLoaded copyWith({
    List<Pole>? poles,
    List<Pole>? originalPoles,
    bool? isSorted,
  }) {
    return PolesListLoaded(
      poles: poles ?? this.poles,
      originalPoles: originalPoles ?? this.originalPoles,
      isSorted: isSorted ?? this.isSorted,
    );
  }

  @override
  List<Object?> get props => [poles, originalPoles, isSorted];
}

/// Состояние ошибки при загрузке опор.
///
/// [exception] содержит возникшее исключение.
class PolesLoadingFailure extends PolesState {
  /// Исключение, возникшее при загрузке опор.
  final Object? exception;

  /// Создает состояние ошибки загрузки.
  PolesLoadingFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}

/// Состояние загрузки при удалении опоры.
///
/// Используется для отображения прогресса удаления.
class DeletePoleLoading extends PolesState {
  @override
  List<Object?> get props => [];
}

/// Состояние успешного удаления опоры.
///
/// Используется, чтобы обновить UI после удаления.
class DeletedPoleLoaded extends PolesState {
  @override
  List<Object?> get props => [];
}

/// Состояние ошибки при удалении опоры.
///
/// [exception] содержит возникшую ошибку.
class DeletePoleFailure extends PolesState {
  /// Исключение, возникшее при удалении.
  final Object? exception;

  /// Создает состояние ошибки удаления.
  DeletePoleFailure({this.exception});

  @override
  List<Object?> get props => [exception];
}
