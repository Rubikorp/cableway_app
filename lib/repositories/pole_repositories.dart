import 'package:cable_road_project/repositories/abstract_pole_repositories.dart';
import 'package:cable_road_project/repositories/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class PoleRepository implements AbstractPoleRepositories {
  final SupabaseClient supabase;

  PoleRepository({required this.supabase});

  @override
  /// Получить всех юзеров
  Future<List<UserInfo>> fetchUsers() async {
    try {
      final responce = await supabase.from('users').select();
      final data = responce as List<dynamic>;
      final users =
          data
              .map((user) => UserInfo.fromJson(user as Map<String, dynamic>))
              .toList();
      return users;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      return [];
    }
  }

  @override
  // Получить все поля
  Future<List<Pole>> fetchPoles() async {
    try {
      final res = await supabase.from('poles').select();
      final data = res as List<dynamic>;
      final poles =
          data
              .map((pole) => Pole.fromJson(pole as Map<String, dynamic>))
              .toList();
      return poles;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      return [];
    }
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
