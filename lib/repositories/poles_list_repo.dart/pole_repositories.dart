import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Репозиторий для управления данными опор (poles).
///
/// Получает, сохраняет, обновляет и удаляет данные опор
/// из удалённого источника (Supabase) и локального кэша (Hive).
class PoleRepository implements AbstractPoleRepositories {
  /// Клиент Supabase для работы с удалённой базой данных.
  final SupabaseClient supabase;

  /// Hive Box для локального хранения опор.
  final Box<Pole> polesBox;

  /// Создаёт [PoleRepository] с необходимыми зависимостями.
  ///
  /// [supabase] — клиент Supabase для сетевых операций.
  /// [polesBox] — локальное хранилище (кэш) для опор.
  PoleRepository({required this.supabase, required this.polesBox});

  @override
  /// Получает список всех опор.
  ///
  /// Сначала пытается загрузить данные с сервера.
  /// В случае ошибки — возвращает данные из локального кэша [polesBox].
  Future<List<Pole>> fetchPoles() async {
    var polesList = <Pole>[];
    try {
      polesList = await _fetchPolesFromApi();

      final polesMap = {for (var e in polesList) e.number: e};

      await polesBox.putAll(polesMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      polesList = polesBox.values.toList();
    }

    return polesList;
  }

  /// Получает опоры с сервера Supabase.
  ///
  /// Преобразует полученные данные в список моделей [Pole].
  Future<List<Pole>> _fetchPolesFromApi() async {
    final res = await supabase.from('poles').select();
    final data = res as List<dynamic>;
    final poles =
        data
            .map((pole) => Pole.fromJson(pole as Map<String, dynamic>))
            .toList();
    return poles;
  }

  @override
  /// Добавляет новую опору [pole] в Supabase.
  ///
  /// Возвращает `true`, если операция успешна, иначе `false`.
  Future<bool> addPole(PoleAdd pole) async {
    try {
      await supabase.from('poles').insert(pole.toJson());
      return true;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      return false;
    }
  }

  @override
  /// Обновляет опору по её [id].
  ///
  /// Можно передать обновлённые [number] и/или [repairs].
  /// Возвращает `true`, если операция прошла успешно.
  Future<bool> updatePole(
    String id, {
    String? number,
    List<Repair>? repairs,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (number != null) updateData['number'] = number;
      if (repairs != null) updateData['repairs'] = repairs;

      await supabase
          .from('poles')
          .update(updateData)
          .eq('id', id)
          .select()
          .single();
      return true;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      return false;
    }
  }

  @override
  /// Удаляет опору по [id] из базы Supabase.
  Future<void> deletePole(String id) async {
    try {
      await supabase.from('poles').delete().eq('id', id);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
    }
  }
}
