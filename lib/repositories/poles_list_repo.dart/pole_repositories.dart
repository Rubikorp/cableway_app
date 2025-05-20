import 'package:cable_road_project/repositories/poles_list_repo.dart/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/poles_list_repo.dart/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PoleRepository implements AbstractPoleRepositories {
  final SupabaseClient supabase;
  final Box<Pole> polesBox;

  PoleRepository({required this.supabase, required this.polesBox});

  @override
  // Получить все поля
  Future<List<Pole>> fetchPoles() async {
    var polesList = <Pole>[];
    try {
      polesList = await _fetchPolesFromApi();

      final polesMap = {for (var e in polesList) e.id: e};

      await polesBox.putAll(polesMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      polesList = polesBox.values.toList();
    }

    return polesList;
  }

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
  /// Добавить новое поле
  Future<bool> addPole(Pole pole) async {
    try {
      await supabase.from('poles').insert(pole.toJson());
      return true;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      return false;
    }
  }

  @override
  /// Обновить поле по ID
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
  /// Удалить поле по ID
  Future<void> deletePole(String id) async {
    try {
      await supabase.from('poles').delete().eq('id', id);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
    }
  }
}
