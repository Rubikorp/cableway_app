import 'package:cable_road_project/repositories/auth_repo.dart/abstract_auth_repositories.dart';
import 'package:cable_road_project/repositories/auth_repo.dart/models/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AuthRepositories implements AbstractAuthRepositories {
  final SupabaseClient supabase;

  AuthRepositories({required this.supabase});

  @override
  /// Получить всех юзеров
  Future<List<UserInfo>> fetchUsers() async {
    var usersList = <UserInfo>[];
    try {
      usersList = await _fetchUsersFromApi();
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
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
