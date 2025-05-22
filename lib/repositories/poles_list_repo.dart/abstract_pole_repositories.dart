import 'package:cable_road_project/repositories/poles_list_repo.dart/models/models.dart';

/// Абстрактный репозиторий для работы с данными опор.
///
/// Описывает базовые операции: получение, добавление, обновление и удаление опор.
abstract class AbstractPoleRepositories {
  /// Получает список всех опор.
  ///
  /// Может вернуть данные из кэша или из удалённого источника.
  Future<List<Pole>> fetchPoles();

  /// Добавляет новую опору [pole] в хранилище.
  ///
  /// Возвращает `true`, если операция прошла успешно, иначе `false`.
  Future<bool> addPole(Pole pole);

  /// Обновляет существующую опору по её [id].
  ///
  /// Можно частично обновить [number] или [repairs].
  /// Возвращает `true`, если обновление прошло успешно.
  Future<bool> updatePole(String id, {String? number, List<Repair>? repairs});

  /// Удаляет опору по её [id].
  ///
  /// В случае ошибки может выбросить исключение.
  Future<void> deletePole(String id);
}
