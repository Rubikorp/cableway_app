import 'package:cable_road_project/repositories/auth_repo.dart/abstract_auth_repositories.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/models/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AuthRepositories implements AbstractAuthRepositories {
  final SupabaseClient supabase;
  final Box<UserInfo> usersBox;

  AuthRepositories({required this.supabase, required this.usersBox});

  @override
  /// Получить всех юзеров
  Future<List<UserInfo>> fetchUsers() async {
    var usersList = <UserInfo>[];
    try {
      usersList = await _fetchUsersFromApi();

      final usersMap = {for (var e in usersList) e.name: e};
      await usersBox.putAll(usersMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      usersList = usersBox.values.toList();
    }

    return usersList;
  }

  Future<List<UserInfo>> _fetchUsersFromApi() async {
    final responce = await supabase.from('users').select();
    final data = responce as List<dynamic>;
    final users =
        data
            .map((user) => UserInfo.fromJson(user as Map<String, dynamic>))
            .toList();
    return users;
  }
}
